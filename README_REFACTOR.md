# UI Refactoring Documentation - June 4, 2026

This document lists the UI and formatting changes made to resolve visual, padding, and layout sizing inconsistencies in the project. Use this document as a quick reference or prompt guide to restore or understand these changes.

---

## 1. Dynamic Currency Symbol Support
- **Issue**: Currency prefixes were statically displaying dollar signs (`$`) or lowercase enum raw strings (e.g. `"idr"`), even when other currencies (like IDR or RM) were selected.
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
    let clean = rawString
        .replacingOccurrences(of: " ", with: "")
    if currency == .idr {
        // IDR: replace all dots (grouping) and commas (invalid decimals)
        let normalized = clean.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
        return Double(normalized) ?? 0.0
    } else {
        // USD/RM: strip grouping commas, resolve decimal point
        var normalized = clean.replacingOccurrences(of: ",", with: "")
        // Handle decimal comma if locale uses comma as separator
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
- **Solution**: Created a computed `url` helper on `VaultItem` model. Replaced the disabled text fields in `TimeoutView` and `ItemJournalCardView` with SwiftUI `Link` views. Tapping them seamlessly redirects to the default browser (Safari).

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
