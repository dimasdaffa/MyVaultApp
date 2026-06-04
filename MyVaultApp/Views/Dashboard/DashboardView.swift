//
//  DashboardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI
import SwiftData
import Combine

struct DashboardView: View {
    @State private var navPath = NavigationPath()
    
    @StateObject private var dashboardVM = DashboardViewModel()
    @EnvironmentObject private var validationVM: ValidationViewModel
    @EnvironmentObject private var journalVM: JournalViewModel
    
    @Query(sort: \VaultItem.targetDate, order: .reverse) private var vaultItems: [VaultItem]
    
    var body: some View { 
        NavigationStack (path: $navPath) { 
            let activeCount = vaultItems.filter { $0.status == .coolingDown || $0.status == .ready }.count
            let slots = dashboardVM.processAndSortItems(vaultItems)

            VStack () {
                // 3. Ask the ViewModel to process the raw SwiftData and pass it to the CardView
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
                .padding(.horizontal, 30)
                Spacer()
            }
            .background(Color.themeBackground)
            // 4. Timer ini tidak terikat pada @State. Ia akan berdetak di background setiap 1 detik.
            // dashboardVM.checkAlertStatus() hanya akan memicu re-render jika `hasReadyItem` atau `zeroCount` berubah!
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                dashboardVM.checkAlertStatus(items: vaultItems)
            }
            // Check the data the exact millisecond SwiftData finishes loading it
            .onChange(of: vaultItems, initial: true) { oldValue, newValue in
                dashboardVM.checkAlertStatus(items: newValue)
            }
            .navigationTitle("MyVault")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: "CreateItem") {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(activeCount >= 3 ? .gray : Color.themePrimary)
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                    }
                    .disabled(activeCount >= 3)
                }
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
        mock1.currency = .idr
        mock1.status = .coolingDown
        
        // Item 2: Ready to validate (timer finished) 
        let mock2 = VaultItem(name: "New Balance 990v6", price: "4.500.000", targetDate: Date().addingTimeInterval(-3600)) // 1 hour ago
        mock2.currency = .idr
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
