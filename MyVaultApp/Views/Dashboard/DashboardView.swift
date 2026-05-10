//
//  DashboardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @State private var navPath = NavigationPath()
    
    @StateObject private var dashboardVM = DashboardViewModel()
    @StateObject private var validationVM = ValidationViewModel()
    @StateObject private var journalVM = JournalViewModel()
    
    @Query private var vaultItems: [VaultItem]
    
    var body: some View { 
        NavigationStack (path: $navPath) { 
            VStack () {
                HStack {
                    Text("MyVault")
                        .font(Font.largeTitle)
                        .bold()
                    Spacer()
                    
                    // 2. Disable the + button if they already have 3 active items!
                    let activeCount = vaultItems.filter { $0.status == .coolingDown || $0.status == .ready }.count
                    
                    NavigationLink(value: "CreateItem") {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(activeCount >= 3 ? .white.opacity(0.5) : .white)
                            .frame(width: 56, height: 56)
                            .background(activeCount >= 3 ? Color.gray : Color.themePrimary)
                            .glassEffect()
                            .tint(activeCount >= 3 ? Color.gray : Color.themePrimary)
                            .shadow(color: activeCount >= 3 ? Color.clear : Color.themePrimary.opacity(1), radius: 10, x: 0, y: 5)
                            .clipShape(Circle())
                    }
                    .disabled(activeCount >= 3)
                }
                .padding(20)
                
                // 3. Ask the ViewModel to process the raw SwiftData and pass it to the CardView
                let slots = dashboardVM.processAndSortItems(vaultItems)
                CardView(navPath: $navPath, itemsForUI: slots, viewModel: dashboardVM)
                    .padding(.top, 8)
                
                HStack{
                    Spacer()
                    Text("Validate your decision!")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .foregroundStyle(Color.themeRed)
                        .phaseAnimator([false, true]) { content, phase in
                            content
                                .opacity(dashboardVM.hasReadyItem ? (phase ? 1.0 : 0.4) : 0.0)
                        } animation: { phase in
                            .easeInOut(duration: 0.8)
                        }
                        .onAppear {
                            dashboardVM.checkAlertStatus(items: vaultItems) 
                        }
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(Color.themeBackground)
            // 4. Every time the clock ticks, check if we need to show the red alert text
            .onReceive(dashboardVM.$currentTime) { _ in
                dashboardVM.checkAlertStatus(items: vaultItems)
            }
            // Check the data the exact millisecond SwiftData finishes loading it
            .onChange(of: vaultItems, initial: true) { oldValue, newValue in
                dashboardVM.checkAlertStatus(items: newValue)
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "CreateItem":
                    CreateItemView(navPath: $navPath)
                case "FirstPage":
                    QuestionJournalView(navPath: $navPath)
                case "ReviewJournal":
                    ReviewJournalView(navPath: $navPath)
                case "EmotionQuestion":
                    EmotionQuestionView(navPath: $navPath)
                case "FinanceQuestion":
                    FinanceQuestionView(navPath: $navPath)
                case "BuyResult":
                    BuyResultView(navPath: $navPath)
                case "NoBuyResult":
                    NoBuyResultView(navPath: $navPath)
                default:
                    EmptyView()
                }
            }
            .navigationDestination(for: VaultItem.self) { selectedItem in
                TimeoutView(navPath: $navPath, item: selectedItem)
            }
        }
        .environmentObject(validationVM)
        .environmentObject(journalVM)
    }
}

// MARK: - Previews

@MainActor
let mockDashboardContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: VaultItem.self, configurations: config)
        
        // Item 1: Actively cooling down (target date in the future)
        let mock1 = VaultItem(name: "Apple Vision Pro", price: "60.000.000", targetDate: Date().addingTimeInterval(86400)) // 1 day from now
        mock1.currency = "IDR"
        mock1.status = .coolingDown
        
        // Item 2: Ready to validate (timer finished) 
        let mock2 = VaultItem(name: "New Balance 990v6", price: "4.500.000", targetDate: Date().addingTimeInterval(-3600)) // 1 hour ago
        mock2.currency = "IDR"
        mock2.status = .coolingDown 
        
        container.mainContext.insert(mock1)
        container.mainContext.insert(mock2)
        
        return container
    } catch {
        fatalError("Failed to create dashboard preview container")
    }
}()

#Preview("Populated Dashboard") {
    DashboardView()
        .modelContainer(mockDashboardContainer)
}

#Preview("Empty Dashboard") {
    DashboardView()
        .modelContainer(for: VaultItem.self, inMemory: true)
}
