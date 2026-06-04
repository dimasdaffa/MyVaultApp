# UI Refactor & Decimal Currency Support (June 4, 2026)

This document records all the UI refactoring, multi-currency decimal formatting, and architectural improvements implemented on **June 4, 2026**. If you need to rebuild or debug this branch, this readme serves as the exact specifications and reference code.

---

## Summary of Changes

1. **Multi-Currency Decimal Support**
   - **USD & RM**: Supports decimal formatting (up to 2 decimal places, e.g. `$2.15` or `RM 2.15`) using `,` as the grouping separator.
   - **IDR**: Retains integer formatting with no decimals, using `.` as the grouping separator.
   - **Form Validation**: Form is valid only if parsed numerical price is strictly greater than 0.
   - **Cooldown Calculation**: Cooldown logic uses the correct parsed double value instead of stripped digits (preventing price scaling errors).

2. **Dynamic Currency Symbols**
   - Replaced hardcoded SFSymbol `dollarsign` prefix labels with dynamic text symbols (`$`, `Rp`, `RM`) corresponding directly to the selected currency.
   - Fixed history item previews to display `Rp 3.333` instead of the raw lowercase enum string description (`idr 3.333`).

3. **HIG-Aligned Typography & Card Layout**
   - **Question cards (Review & Timeout)**: Question headers styled with `14pt` (Semibold, Secondary) and answers styled with `17pt` (Regular, Primary) for maximum readability.
   - **Overlapping Pencil Icon Fixed**: Replaced Text-overlay with a top-aligned `HStack` container to separate question text wrapping from the edit pencil button.
   - **Recessed Input Field**: Re-styled the journaling input field in `QuestionJournalView.swift` as a rounded corner card (`24pt`) filled with `Color.themeBackground` (#FAFAF6) to look elegantly recessed/sunken into the `themeCard` card, matching Apple HIG guidelines.
   - **Consistent Backgrounds**: Wrapped screens (`TimeoutView`, `QuestionJournalView`, `ReviewJournalView`) in `ZStack` containing `Color.themeBackground.ignoresSafeArea()` to prevent cards from blending into standard white default backgrounds.

4. **Clickable Links (MVVM-Aligned)**
   - Implemented a model-level computed property `url: URL?` on `VaultItem` that automatically handles cleanup and prefix formatting.
   - Replaced static text labels in views with SwiftUI `Link` buttons.

---

## File Changes & Code Details

### 1. Model Changes

#### `Models/CurrencyModel.swift`
Added a computed property to get the currency symbol:
```swift
var symbol: String {
    switch self {
    case .rm: return "RM"
    case .idr: return "Rp"
    case .usd: return "$"
    }
}
```

#### `Models/VaultItemModel.swift`
Added a model-level computed property to return a valid URL:
```swift
var url: URL? {
    guard !link.isEmpty else { return nil }
    let cleanLink = link.trimmingCharacters(in: .whitespacesAndNewlines)
    if cleanLink.lowercased().hasPrefix("http://") || cleanLink.lowercased().hasPrefix("https://") {
        return URL(string: cleanLink)
    } else {
        return URL(string: "https://" + cleanLink)
    }
}
```

---

### 2. ViewModel Changes

#### `ViewModels/CreateItemViewModel.swift`
Updated price validation, cooldown calculations, and formatting to support decimals:

* **Validation**:
```swift
var isFormValid: Bool {
    let isTitleValid = !itemTitle.trimmingCharacters(in: .whitespaces).isEmpty
    let parsedPrice = parsePriceDouble(itemPrice, currency: selectedCurrency)
    let isPriceValid = parsedPrice > 0
    return isTitleValid && isPriceValid
}
```

* **Decimal Parsing & Extraction**:
```swift
private func parseParts(_ input: String) -> (integer: String, decimal: String?) {
    if input.isEmpty { return ("", nil) }
    if let lastSeparatorIndex = input.lastIndex(where: { $0 == "." || $0 == "," }) {
        let afterSeparator = input[input.index(after: lastSeparatorIndex)...]
        let isDecimal: Bool
        if input[lastSeparatorIndex] == "." {
            isDecimal = true
        } else {
            isDecimal = afterSeparator.isEmpty || afterSeparator.count < 3
        }
        if isDecimal {
            let beforeSeparator = input[..<lastSeparatorIndex]
            let cleanInteger = beforeSeparator.filter { "0123456789".contains($0) }
            let cleanDecimal = afterSeparator.filter { "0123456789".contains($0) }
            return (cleanInteger, String(cleanDecimal.prefix(2)))
        }
    }
    let cleanInteger = input.filter { "0123456789".contains($0) }
    return (cleanInteger, nil)
}

private func parsePriceDouble(_ priceString: String, currency: Currency) -> Double {
    if currency == .idr {
        let cleanString = priceString.replacingOccurrences(of: ".", with: "")
        return Double(cleanString) ?? 0
    } else {
        let cleanString = priceString.replacingOccurrences(of: ",", with: "")
        return Double(cleanString) ?? 0
    }
}
```

* **Dynamic Formatting**:
```swift
private func formatCurrency(_ value: String, currency: Currency) -> String {
    if currency == .idr {
        let numbersOnly = value.filter { "0123456789".contains($0) }
        guard let number = Int(numbersOnly) else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? ""
    } else {
        let (integerPart, decimalPart) = parseParts(value)
        let formattedInteger: String
        if let number = Int(integerPart) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formattedInteger = formatter.string(from: NSNumber(value: number)) ?? ""
        } else {
            formattedInteger = integerPart.isEmpty ? "" : "0"
        }
        if let decimal = decimalPart {
            let displayInteger = integerPart.isEmpty ? "0" : formattedInteger
            return displayInteger + "." + decimal
        } else {
            return formattedInteger
        }
    }
}
```

---

### 3. View Changes

#### `Views/Journal/CreateItemView.swift`
- Changed price text field keyboard type to `.decimalPad`.
- Replaced SFSymbol `dollarsign` with dynamic text: `Text(viewModel.selectedCurrency.symbol)`.

#### `Views/Journal/QuestionJournalView.swift`
- Wrapped content in a `ZStack` containing `Color.themeBackground.ignoresSafeArea()`.
- Changed multiline `TextField` layout to a recessed rounded container:
```swift
VStack {
    TextField("Express your thoughts here...", text: currentAnswerBinding, axis: .vertical)
        .lineLimit(4...8)
        .font(.system(size: 18))
        .padding(20)
        .background(Color.themeBackground)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
}
```

#### `Views/Journal/ReviewJournalView.swift`
- Wrapped content in a `ZStack` containing `Color.themeBackground.ignoresSafeArea()`.
- Restructured cards using a top-aligned `HStack` to prevent overlapping:
```swift
VStack(alignment: .leading, spacing: 12) {
    HStack(alignment: .top) {
        Text(question.text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        if canEdit {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color.themePrimary.opacity(0.6))
                .font(.system(size: 16, weight: .semibold))
        }
    }
    
    Text(question.answer.isEmpty ? "No thoughts provided." : question.answer)
        .font(.system(size: 17, weight: .regular))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
}
.padding(25)
.background(
    RoundedRectangle(cornerRadius: 30)
        .fill(Color.themeCard)
        .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
)
```

#### `Views/Validation/TimeoutView.swift`
- Wrapped body in a `ZStack` containing `Color.themeBackground.ignoresSafeArea()`.
- Price dynamic symbol text replaces dollar SFSymbol: `Text(item.currency.symbol)`.
- Clickable link implementation:
```swift
HStack {
    Image(systemName: "link")
        .font(.system(size: 20))
        .foregroundColor(item.link.isEmpty ? .gray : Color.themePrimary)
    
    if let url = item.url {
        Link(item.link, destination: url)
            .font(.body)
            .foregroundColor(Color.themePrimary)
            .underline()
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    } else {
        Text(item.link.isEmpty ? "No link provided" : item.link)
            .foregroundColor(.gray)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
```

#### `Views/Components/ItemJournalCardView.swift`
- Clickable link implementation:
```swift
if !item.link.isEmpty {
    HStack(spacing: 12) {
        Image(systemName: "link")
            .font(.system(size: 22))
        
        if let url = item.url {
            Link(item.link, destination: url)
                .font(.system(size: 24))
                .foregroundColor(Color.themePrimary)
                .underline()
                .lineLimit(1)
        } else {
            Text(item.link)
                .font(.system(size: 24))
                .foregroundColor(Color.themePrimary)
                .underline()
                .lineLimit(1)
        }
    }
}
```

#### `Views/History/HistoryView.swift`
- Displays `Rp` / `$` / `RM` symbols instead of lowercase rawValue:
```swift
Text("\(item.currency.symbol) \(item.price)")
```
