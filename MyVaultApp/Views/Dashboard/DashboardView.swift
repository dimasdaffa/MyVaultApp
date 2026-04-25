//
//  DashboardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI

struct DashboardView: View {
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $navPath) {
            VStack () {
                HStack {
                    Text("MyVault")
                        .font(Font.largeTitle)
                        .bold()
                    Spacer()
                    NavigationLink(value: "CreateItem") {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.themePrimary)
                            .glassEffect()
                            .tint(Color.themePrimary)
                            .shadow(color: Color.themePrimary.opacity(1), radius: 10, x: 0, y: 5)
                            .clipShape(Circle())
                    }
                }
                .padding(20)
                
                CardView(navPath: $navPath)
                    .padding(.top, 16)
                
                HStack{
                    Spacer()
                    Text("Validate your decision!")
                        .font(.system(size: 8))
                        .fontWeight(.light)
                        .foregroundStyle(Color.themeRed)
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(Color.themeBackground)
            .navigationDestination(for: String.self) { route in
                            switch route {
                            case "CreateItem":
                                CreateItemView(navPath: $navPath)
                            case "FirstPage":
                                QuestionJournalView(navPath: $navPath)
                            case "ReviewJournal":
                                ReviewJournalView(navPath: $navPath)
                            case "Timeout":
                                TimeoutView(navPath: $navPath)
                            case "EmotionQuestion":
                                EmotionQuestionView(navPath: $navPath)
                            case "FinanceQuestion":
                                FinanceQuestionView(navPath: $navPath)
                            case "SuccessResult":
                                SuccessResultView(navPath: $navPath)
                            default:
                                EmptyView()
                            }
                        }
        }
    }
}

#Preview {
    DashboardView()
}
