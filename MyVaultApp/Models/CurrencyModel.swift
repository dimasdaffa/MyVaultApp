//
//  CurrencyModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/05/26.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable, Codable {
	case rm = "RM"
	case idr = "IDR"
	case usd = "USD"

	var id: String { rawValue }

	var symbol: String {
		switch self {
		case .rm: return "RM"
		case .idr: return "Rp"
		case .usd: return "$"
		}
	}
}
