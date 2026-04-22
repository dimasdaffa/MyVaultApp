//
//  MyVaultAppApp.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 19/04/26.
//

import SwiftUI

@main
struct MyVaultApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
    }
}
