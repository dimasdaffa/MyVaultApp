//
//  TimeoutView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI
import SwiftData

struct TimeoutView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var validationVM: ValidationViewModel
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.vaultItemRepositoryFactory) private var repositoryFactory
    
    @StateObject private var viewModel = TimeoutViewModel()
    let item: VaultItem

    @State private var showJournalSheet = false
    @State private var showDeleteAlert = false

    private var repository: any VaultItemRepository {
        repositoryFactory(modelContext)
    }

    init(navPath: Binding<NavigationPath>, item: VaultItem) {
        self._navPath = navPath
        self.item = item
    }
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: -15) {
                        HStack {
                            Text(viewModel.isTimerFinished ? "Time" : "Cooling")
                                .font(.system(size: 45))
                                .bold()
                            Text(viewModel.isTimerFinished ? "Out." : "Down.")
                                .font(.system(size: 45))
                                .bold()
                                .foregroundColor(Color.themePrimary)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                HStack {
                    VStack(alignment: .leading) {
                        if viewModel.isTimerFinished {
                            Text("Review your mood and your bank")
                                .font(.system(size: 19))
                                .fontWeight(.light)
                            Text("account one last time before")
                                .font(.system(size: 19))
                                .fontWeight(.light)
                            Text("making the call.")
                                .font(.system(size: 19))
                                .fontWeight(.light)
                        } else {
                            Text("Take a deep breath and let your")
                                .font(.system(size: 19))
                                .fontWeight(.light)
                            Text("emotions settle down before")
                                .font(.system(size: 19))
                                .fontWeight(.light)
                            Text("making a decision.")
                                .font(.system(size: 19))
                                .fontWeight(.light)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                VStack {
                    HStack {
                        Text("PRODUCT TITLE")
                            .font(.system(size: 15))
                            .bold()
                        Spacer()
                    }
                    TextField("", text: .constant(item.name))
                        .foregroundColor(.primary)
                        .disabled(true)
                        .padding(19)
                        .background(Color.themeCard)
                        .cornerRadius(42)
                }
                .padding(.top, 14)
                .padding(.horizontal, 30)
                
                VStack {
                    HStack {
                        Text("PRICE")
                            .font(.system(size: 15))
                            .bold()
                        Spacer()
                        Text("CURRENCY")
                            .font(.system(size: 15))
                            .bold()
                            .offset(x: -45)
                    }
                    HStack {
                        HStack {
                            Text(item.currency.symbol)
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.secondary)
                            TextField("", text: .constant(item.price))
                                .disabled(true)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: 400)
                        .padding(19)
                        .background(Color.themeCard)
                        .cornerRadius(42)
                        
                        HStack {
                            Text(item.currency.rawValue)
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                                .disabled(true)
                        }
                        .frame(maxWidth: 100)
                        .padding(19)
                        .background(Color.themeCard)
                        .cornerRadius(42)
                    }
                }
                .padding(.top, 14)
                .padding(.horizontal, 30)
                
                VStack {
                    HStack {
                        Text("SOURCE LINK")
                            .font(.system(size: 15))
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "link")
                            .font(.system(size: 20))
                            .foregroundColor(item.link.isEmpty ? .gray : Color.themePrimary)
                        
                        if let url = item.url {
                            Link(item.link, destination: url)
                                .font(.body)
                                .foregroundColor(Color.themePrimary)
                                .underline()
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(item.link.isEmpty ? "No link provided" : item.link)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(19)
                    .background(Color.themeCard)
                    .cornerRadius(42)
                }
                .padding(.top, 14)
                .padding(.horizontal, 30)
                
                HStack {
                    Spacer()
                    Button {
                        journalVM.loadItem(item)
                        showJournalSheet = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text(viewModel.isTimerFinished ? "Read Initial Thoughts" : "Review & Edit Thoughts")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.themePrimary)
                        .underline()
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 30)
                
                Spacer()
                
                // THE LIVE TICKING DISPLAY
                VStack {
                    Text("REMAINING DURATION")
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    HStack(spacing: 0) {
                        Text("\(viewModel.hours):")
                            .foregroundStyle(Color.themeBackground)
                        Text("\(viewModel.minutes)")
                            .foregroundStyle(viewModel.isTimerFinished ? Color.themePrimary : Color.themeBackground)
                        Text(":\(viewModel.seconds)")
                            .foregroundStyle(Color.themeBackground)
                    }
                    .font(.system(size: 58))
                    .monospacedDigit()
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 42)
                        .fill(Color.themeBlack)
                )
                .padding(.horizontal, 30)
                
                Button {
                    validationVM.startValidation(for: item)
                    navPath.append("EmotionQuestion")
                } label: {
                    Text("Validate Answer")
                        .fontWeight(.medium)
                        .foregroundColor(viewModel.isTimerFinished ? .white : .gray)
                        .frame(width: 350, height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(viewModel.isTimerFinished ? Color.themePrimary : Color.gray.opacity(0.3))
                        )
                        .shadow(color: viewModel.isTimerFinished ? Color.themePrimary.opacity(0.8) : Color.clear, radius: 10, x: 0, y: 5)
                }
                .disabled(!viewModel.isTimerFinished)
                
            }
        }
        .navigationTitle(viewModel.isTimerFinished ? "Validation" : "Cooling Down")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setup(with: item)
        }
        .sheet(isPresented: $showJournalSheet) {
            NavigationStack {
                ReviewJournalView(navPath: .constant(NavigationPath()), isPresentedAsSheet: true, canEdit: !viewModel.isTimerFinished)
            }
            .environmentObject(journalVM)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.themePrimary)
                }
            }
        }
        .alert("Discard Item", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                // Delete it permanently from SwiftData
                repository.delete(item)
                // Pop back to the Dashboard
                navPath.removeLast()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove this item from your vault? This action cannot be undone.")
        }
    }
}

#Preview("Cooling Down") {
    NavigationStack {
        TimeoutView(
            navPath: .constant(NavigationPath()),
            item: VaultItem(
                name: "New Balance 740",
                price: "1.740.000",
                currency: .idr,
                targetDate: Date().addingTimeInterval(172000)
            )
        )
        .environmentObject(JournalViewModel())
        .environmentObject(ValidationViewModel())
    }
}

#Preview("Timeout") {
    NavigationStack {
        TimeoutView(
            navPath: .constant(NavigationPath()),
            item: VaultItem(
                name: "Apple Vision Pro",
                price: "60.000.000",
                currency: .idr,
                targetDate: Date().addingTimeInterval(-3600)
            )
        )
        .environmentObject(JournalViewModel())
        .environmentObject(ValidationViewModel())
    }
}
