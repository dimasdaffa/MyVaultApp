//
//  HistoryViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 05/05/26.
//

import Foundation
import SwiftData
import Combine

class HistoryViewModel: ObservableObject {
    
    // Filter out active items to only show the past
    func getHistory(from allItems: [VaultItem]) -> [VaultItem] {
        return allItems.filter { $0.status != .coolingDown && $0.status != .ready }
    }
    
    // Handle the database deletion
    func deleteItems(at offsets: IndexSet, from historyItems: [VaultItem], repository: any VaultItemRepository) {
        for index in offsets {
            let itemToDelete = historyItems[index]
            NotificationManager.shared.cancelNotification(for: itemToDelete)
            repository.delete(itemToDelete)
        }
    }
}
