//
//  CooldownPolicy.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 31/05/26.
//

import Foundation

struct CooldownPolicy {
    static let `default` = CooldownPolicy()

    func cooldownDuration(for priceString: String, currency: Currency) -> TimeInterval {
        let cleanPrice = parsePriceDouble(priceString, currency: currency)

        switch currency {
        case .idr:
            if cleanPrice < 5000 { return 60 }            // Testing
            if cleanPrice < 500000 { return 86400 }       // 24h
            if cleanPrice <= 5000000 { return 172800 }    // 48h
            return 259200                                 // 72h
        case .usd:
            if cleanPrice < 35 { return 86400 }
            if cleanPrice <= 350 { return 172800 }
            return 259200
        case .rm:
            if cleanPrice < 150 { return 86400 }
            if cleanPrice <= 1500 { return 172800 }
            return 259200
        }
    }

    func parsePriceDouble(_ priceString: String, currency: Currency) -> Double {
        if currency == .idr {
            let cleanString = priceString.replacingOccurrences(of: ".", with: "")
            return Double(cleanString) ?? 0
        } else {
            // Remove grouping commas
            let cleanString = priceString.replacingOccurrences(of: ",", with: "")
            return Double(cleanString) ?? 0
        }
    }
}
