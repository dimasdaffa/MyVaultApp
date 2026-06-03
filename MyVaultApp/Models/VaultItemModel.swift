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
    var currency: Currency
    var link: String
    var dateAdded: Date
    var targetDate: Date
    var status: ItemStatus
    var emotionAnswer: String
    var financeAnswer: String
    var cooldownDuration: TimeInterval
    
    // The initializer creates a brand new entry
    init(name: String, price: String = "", currency: Currency = .idr, link: String = "", targetDate: Date, cooldownDuration: TimeInterval = 86400) {
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
        self.cooldownDuration = cooldownDuration
    }
}

