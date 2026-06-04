# UI & Logic Refactoring Documentation - June 4, 2026

This document lists the UI, formatting, database, and notification system changes made to resolve visual, padding, and saving issues. Use this document to quickly restore or understand the modifications.

---

## 1. Dynamic Currency Symbol Support
- **Issue**: Currency prefixes were statically displaying dollar signs (`$`) or lowercase raw strings (e.g. `"idr"`).
- **Solution**:
  - Added a computed `symbol` property to the `Currency` model.
  - Replaced static dollar images and raw descriptions with the dynamic `symbol` across inputs, lists, cards, and detail pages.

### Code Reference - Currency Model Extension
```swift
// Models/Enums/Currency.swift
enum Currency: String, Codable, CaseIterable, Identifiable {
    case usd = "USD"
    case idr = "IDR"
    case rm = "RM"
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .idr: return "Rp"
        case .rm: return "RM"
        }
    }
}
```

---

## 2. Decimal Inputs & Parsing (USD/RM vs IDR)
- **Issue**: USD and RM inputs were not supporting decimals (cents/sen), and typing a decimal point broke calculations (treating `$2.15` as `$215`).
- **Solution**:
  - Keyboard changed to `.decimalPad`.
  - Implemented custom decimal and grouping normalizers in the model and viewmodel.
  - USD/RM allows up to 2 decimal places, while IDR remains whole numbers.
  - Moved parsing logic (`parsePriceDouble`) to `CooldownPolicy.swift` so it is reusable and MVVM-compliant.

### Code Reference - Double Price Parsing
```swift
// Models/CooldownPolicy.swift
static func parsePriceDouble(_ rawString: String, currency: Currency) -> Double {
    let clean = rawString.replacingOccurrences(of: " ", with: "")
    if currency == .idr {
        let normalized = clean.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
        return Double(normalized) ?? 0.0
    } else {
        var normalized = clean.replacingOccurrences(of: ",", with: "")
        if normalized.contains(",") && !normalized.contains(".") {
            normalized = normalized.replacingOccurrences(of: ",", with: ".")
        }
        return Double(normalized) ?? 0.0
    }
}
```

---

## 3. HIG Recessed TextFields (Observations Editor)
- **Issue**: The writing fields in journaling pages looked like plain, unstyled text fields.
- **Solution**: Designed a premium Apple HIG card container: wrapped the multiline `TextField` inside a padded container using `Color.themeBackground` with rounded corners (`24pt`) and a subtle outline border.

---

## 4. Clickable External Links
- **Issue**: Source links were plain text inside disabled fields.
- **Solution**: Created a computed `url` helper on `VaultItem` model. Replaced the disabled text fields in `TimeoutView` and `ItemJournalCardView` with SwiftUI `Link` views. Tapping them redirects to the default browser (Safari).

---

## 5. Horizontal Layout Padding & Margin Unification
- **Issue**: Horizontal padding values were inconsistent (mixes of `31`, `25`, `43`, `44`, `50`, and default insets) and buttons were constrained to a hardcoded `350` width, clipping on small screens.
- **Solution**: Consolidated all horizontal padding and margins into two distinct categories:

### A. Main Screen Margins (30pt)
Unified card backgrounds, lists, text fields, and button margins to **`30pt`**:
- **History list items** (`HistoryView`):
  - Changed `listRowInsets` trailing/leading to `30pt`.
  - Updated card `cornerRadius` from `25` to `30` to match other cards.
- **Result Cards** (`BuyResultView` and `NoBuyResultView`):
  - Changed black status card `.padding(.horizontal)` to `30`.
- **Adaptive Buttons**:
  - Replaced hardcoded `.frame(width: 350, height: 62)` with `.frame(maxWidth: .infinity)` and `.frame(height: 62)`.
  - Added `.padding(.horizontal, 30)` to the buttons.
  - Applies to: `CreateItemView`, `TimeoutView`, `BuyResultView`, and `NoBuyResultView`.

### B. Wizard Flow Margins (44pt)
Unified inner content alignment and progress indicators in step-by-step flows to **`44pt`**:
- Changed `ProgressBarView` internal padding from `43` to `44`.
- Checked and verified that all inner labels, textfields, and choices in `QuestionJournalView`, `EmotionQuestionView`, and `FinanceQuestionView` use `.padding(.horizontal, 44)`.

---

## 6. Physical Device Saving Bug Fix
- **Issue**: Newly created items were not saving and no timer item was appearing on physical iOS devices, while the simulator saved and worked correctly.
- **Root Cause**: On physical devices running older iOS 17.x versions, instantiating a `@Model` object on the main thread/actor implicitly associates it with a context before `insert()` is explicitly called. This caused the safety check `if finalItemToSave.modelContext == nil` to evaluate to `false` and bypass insertion/saving entirely.
- **Solution**: Removed the redundant `modelContext == nil` check in the save button action within `ReviewJournalView.swift`. New items are now inserted and saved unconditionally.

---

## 7. Local Notification System
- **Issue**: No feedback was sent to the user's device when the cooldown timer ended. In addition, the notification badge would get stuck at "1" and not clear when the app was opened, deleted, or validated.
- **Solution**: Scheduled local alerts using the iOS `UserNotifications` framework.
  - On startup, the app requests permission (`.alert`, `.sound`, `.badge`).
  - Upon item save in [ReviewJournalView.swift](file:///Users/dimasdaffa/Documents/swifties/MyVaultApp/MyVaultApp/Views/Journal/ReviewJournalView.swift), a notification is scheduled with the title `"Cooling Down Finished!"` and body `"Time is up for \(item.name). You can now validate your decision!"` triggered at `targetDate` using the item's UUID as identifier.
  - Upon deletion in [TimeoutView.swift](file:///Users/dimasdaffa/Documents/swifties/MyVaultApp/MyVaultApp/Views/Validation/TimeoutView.swift) or [HistoryViewModel.swift](file:///Users/dimasdaffa/Documents/swifties/MyVaultApp/MyVaultApp/ViewModels/HistoryViewModel.swift), any pending scheduled alerts matching the item's UUID are cancelled automatically.
  - Reset the badge count to `0` and clear all delivered notifications automatically when the app transitions back to the active state (`.active` scene phase) in `MyVaultApp.swift`.
