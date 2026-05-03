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
    @State private var isPulsing = false
    
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
                
                HStack{
                    Spacer()
                    Text("Validate your decision!")
                        .font(.system(size: 8))
                        .fontWeight(.light)
                        .foregroundStyle(Color.themeRed)
                        .opacity(dashboardVM.hasReadyItem ? (isPulsing ? 1.0 : 0.4) : 0.0)
                        .scaleEffect(dashboardVM.hasReadyItem && isPulsing ? 1.05 : 1.0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                isPulsing = true
                            }
                        }
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(Color.themeBackground.ignoresSafeArea())
            // 4. Every time the clock ticks, check if we need to show the red alert text
            .onReceive(dashboardVM.$currentTime) { _ in
                dashboardVM.checkAlertStatus(items: vaultItems)
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "CreateItem":
                    CreateItemView(navPath: $navPath)
                case "FirstPage":
                    QuestionJournalView(navPath: $navPath)
                case "ReviewJournal":
                    ReviewJournalView(navPath: $navPath)
                case "Timeout_Ready":
                    TimeoutView(navPath: $navPath, isTimerFinished: true)
                case "Timeout_Waiting":
                    TimeoutView(navPath: $navPath, isTimerFinished: false)
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
        }
        .environmentObject(validationVM)
        .environmentObject(journalVM)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: VaultItem.self, inMemory: true)
}
