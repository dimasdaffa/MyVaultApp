//
//  HistoryView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI
import SwiftData
import Combine

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journalVM: JournalViewModel
    
    @StateObject private var viewModel = HistoryViewModel()
    
    @Query(sort: \VaultItem.targetDate, order: .reverse) private var allItems: [VaultItem]
    
    @State private var selectedItem: VaultItem?
    @State private var showDetailSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                // Ask the ViewModel for the filtered list
                let historyItems = viewModel.getHistory(from: allItems)
                
                if historyItems.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "archivebox")
                            .font(Font.largeTitle)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("Your vault history is empty.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(historyItems) { item in
                            historyCard(for: item)
                                .onTapGesture {
                                    journalVM.loadItem(item)
                                    selectedItem = item
                                    showDetailSheet = true
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
                        }
                        .onDelete { offsets in
                            viewModel.deleteItems(at: offsets, from: historyItems, context: modelContext)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, 15)
                }
            }
            .navigationTitle("History")
            .sheet(isPresented: $showDetailSheet) {
                NavigationStack {
                    ReviewJournalView(
                        navPath: .constant(NavigationPath()),
                        isPresentedAsSheet: true,
                        canEdit: false
                    )
                }
                .environmentObject(journalVM)
            }
        }
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    func historyCard(for item: VaultItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(item.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Spacer()
                
                let isBought = item.status == .bought
                
                Text(isBought ? "BOUGHT" : "PASSED")
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isBought ? Color.themePrimary.opacity(0.15) : Color.gray.opacity(0.15))
                    .foregroundColor(isBought ? Color.themePrimary : .gray)
                    .clipShape(Capsule())
            }
            
            HStack {
                Text("\(item.currency.symbol) \(item.price)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(item.targetDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.themeCard)
        )
    }
}

// MARK: - Previews

@MainActor
let mockContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: VaultItem.self, configurations: config)
        
        let mock1 = VaultItem(name: "Sony WH-1000XM5", price: "5.500.000", targetDate: Date().addingTimeInterval(-86400))
        mock1.currency = .idr
        mock1.status = .bought
        
        let mock2 = VaultItem(name: "Mechanical Keyboard", price: "2.100.000", targetDate: Date().addingTimeInterval(-172800))
        mock2.currency = .idr
        mock2.status = .saved
        
        container.mainContext.insert(mock1)
        container.mainContext.insert(mock2)
        
        return container
    } catch {
        fatalError("Failed to create preview container")
    }
}()

#Preview("Populated History") {
    HistoryView()
        .modelContainer(mockContainer)
        .environmentObject(JournalViewModel())
}

#Preview("Empty History") {
    HistoryView()
        .modelContainer(for: VaultItem.self, inMemory: true)
        .environmentObject(JournalViewModel())
}
