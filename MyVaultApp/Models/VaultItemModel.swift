//
//  VaultItemModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 02/05/26.
//

import Foundation

struct VaultItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var timeRemaining: TimeInterval
    var isEmpty: Bool
}
