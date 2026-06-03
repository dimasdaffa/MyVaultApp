//
//  ItemStatus.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/06/26.
//

import Foundation

// A simple list of states our item can be in
enum ItemStatus: String, Codable {
    case coolingDown = "Cooling Down" // Timer is ticking
    case ready = "Ready to Validate" // Timer done
    case bought = "Bought" // Failed test = buy
    case saved = "Saved" // Passed test = no buy
}
