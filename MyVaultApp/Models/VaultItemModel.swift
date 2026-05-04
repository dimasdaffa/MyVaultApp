//
//  VaultItemModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 02/05/26.
//

import Foundation
import SwiftData

@Model
class VaultItem {
    var id: UUID
    var name: String
    var price: String
    var currency: String
    var link: String
    var dateAdded: Date
    var targetDate: Date
    var status: ItemStatus
    var emotionAnswer: String
    var financeAnswer: String
    
    // The initializer creates a brand new entry
    init(name: String, price: String = "", currency: String = "IDR", link: String = "", targetDate: Date) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.currency = currency
        self.link = link
        self.dateAdded = Date()
        self.targetDate = targetDate
        self.status = ItemStatus.coolingDown
        self.emotionAnswer = ""
        self.financeAnswer = ""
    }
}

// A simple list of states our item can be in
enum ItemStatus: String, Codable {
    case coolingDown = "Cooling Down" // Timer is ticking
    case ready = "Ready to Validate" // Timer done
    case bought = "Bought" // Failed test = buy
    case saved = "Saved" // Passed test = no buy
}
