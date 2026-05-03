//
//  CurrencyModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/05/26.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable {
	case rm = "RM"
	case idr = "IDR"
	case usd = "USD"

	var id: String { rawValue }
}
