//
//  CreateItemViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/05/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class CreateItemViewModel: ObservableObject {
	@Published var selectedCurrency: Currency = .idr
	@Published var itemTitle: String = ""
	@Published var itemPrice: String = ""
	@Published var itemLink: String = ""

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

	@discardableResult
	func saveItem(modelContext: ModelContext, journalVM: JournalViewModel) -> VaultItem? {
		guard isFormValid else { return nil }

		let target = Date().addingTimeInterval(60)
		let newItem = VaultItem(
			name: itemTitle,
			price: itemPrice,
			currency: selectedCurrency.rawValue,
			link: itemLink,
			targetDate: target
		)

		modelContext.insert(newItem)
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
