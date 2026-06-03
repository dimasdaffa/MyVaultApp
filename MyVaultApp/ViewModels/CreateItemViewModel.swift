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
        let isPriceValid = !itemPrice.trimmingCharacters(in: .whitespaces).isEmpty && itemPrice != "0"
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
    
    private func formatCurrency(_ value: String, currency: Currency) -> String {
        let numbersOnly = value.filter { "0123456789".contains($0) }
        guard let number = Int(numbersOnly) else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        switch currency {
        case .idr:
            formatter.groupingSeparator = "."
        case .usd, .rm:
            formatter.groupingSeparator = ","
        }
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    
}
