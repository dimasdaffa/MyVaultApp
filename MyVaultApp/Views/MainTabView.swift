//
//  MainTabView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 19/04/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
                    
                    DashboardView() 
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    
                    HistoryView()
                        .tabItem {
                            Image(systemName: "book.pages")
                            Text("History")
                        }
                        .tag(1)
                    
                    
                }
                .fontDesign(.rounded)
                .tint(.themePrimary)
            }
}

#Preview {
    MainTabView()
}
