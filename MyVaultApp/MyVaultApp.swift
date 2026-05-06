//
//  MyVaultApp.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 19/04/26.
//

import SwiftUI
import SwiftData

@main
struct MyVaultApp: App {
    @StateObject private var journalVM = JournalViewModel()
    @StateObject private var validationVM = ValidationViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(journalVM)
                .environmentObject(validationVM)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: VaultItem.self)
    }
}
