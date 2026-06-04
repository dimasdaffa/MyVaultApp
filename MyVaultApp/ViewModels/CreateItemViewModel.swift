//
//  CreateItemViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/05/26.
//

import Foundation
import Combine

@MainActor
final class CreateItemViewModel: ObservableObject {
    @Published var selectedCurrency: Currency = .idr
    @Published var itemTitle: String = ""
    @Published var itemPrice: String = ""
    @Published var itemLink: String = ""

    private let cooldownPolicy = CooldownPolicy.default
    
    var isFormValid: Bool {
        let isTitleValid = !itemTitle.trimmingCharacters(in: .whitespaces).isEmpty
        let parsedPrice = cooldownPolicy.parsePriceDouble(itemPrice, currency: selectedCurrency)
        let isPriceValid = parsedPrice > 0
        return isTitleValid && isPriceValid
    }
    
    func onPriceChanged(_ newValue: String) {
        itemPrice = formatCurrency(newValue, currency: selectedCurrency)
    }
    
    func onCurrencyChanged() {
        itemPrice = formatCurrency(itemPrice, currency: selectedCurrency)
    }
    
    // Create the VaultItem in memory and hand it to the JournalViewModel.
    // only when the user taps the checkmark to confirm.
    @discardableResult
    func prepareItem(journalVM: JournalViewModel) -> VaultItem? {
        guard isFormValid else { return nil }
        
        // Wipe any leftover state from a previous cancelled journal flow
        journalVM.resetJournal()
        
        // Calculate the duration based on price and currency
        let duration = cooldownPolicy.cooldownDuration(for: itemPrice, currency: selectedCurrency)
        
        let newItem = VaultItem(
            name: itemTitle,
            price: itemPrice,
            currency: selectedCurrency,
            link: itemLink,
            targetDate: Date(), // Placeholder
            cooldownDuration: duration // Pass the calculated duration
        )
        
        journalVM.activeItem = newItem
        return newItem
    }
    
    private func parseParts(_ input: String) -> (integer: String, decimal: String?) {
        if input.isEmpty { return ("", nil) }
        
        // Find the last occurrence of "." or "," which could act as a decimal point.
        if let lastSeparatorIndex = input.lastIndex(where: { $0 == "." || $0 == "," }) {
            let afterSeparator = input[input.index(after: lastSeparatorIndex)...]
            
            // Check if this separator is a grouping separator or a decimal separator.
            // In USD/RM, a grouping separator is "," and is typically followed by exactly 3 digits.
            // Any "." is a decimal separator. Any "," followed by 0, 1, or 2 digits is a decimal separator.
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
        
        // No decimal separator found
        let cleanInteger = input.filter { "0123456789".contains($0) }
        return (cleanInteger, nil)
    }
    
    private func formatCurrency(_ value: String, currency: Currency) -> String {
        if currency == .idr {
            let numbersOnly = value.filter { "0123456789".contains($0) }
            guard let number = Int(numbersOnly) else { return "" }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            return formatter.string(from: NSNumber(value: number)) ?? ""
        } else {
            // USD or RM
            let (integerPart, decimalPart) = parseParts(value)
            
            // Format the integer part
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
                // If decimal is not nil, it means there is a decimal separator.
                // Reconstruct as formattedInteger + "." + decimal.
                // If integerPart is empty (e.g. user typed "."), formattedInteger defaults to "0".
                let displayInteger = integerPart.isEmpty ? "0" : formattedInteger
                return displayInteger + "." + decimal
            } else {
                return formattedInteger
            }
        }
    }
    
    
}
