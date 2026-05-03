//
//  ReviewJournalView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI
import SwiftData

struct ReviewJournalView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var journalVM: JournalViewModel
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    var isPresentedAsSheet: Bool = false
    var canEdit: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 35) {
                
                // Sembunyikan Header Kartu Barang jika sedang di dalam Timeout Sheet
                if !isPresentedAsSheet {
                    if let activeItem = journalVM.activeItem {
                        ItemJournalCardView(item: activeItem)
                    }
                }
                
                HStack {
                    Text("Observations")
                        .font(.system(size: 28))
                        .bold()
                    Spacer()
                    Text("\(journalVM.questions.count) Entries")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 30)
                
                VStack(spacing: 20) {
                    ForEach(Array(journalVM.questions.enumerated()), id: \.element.text) { index, question in
                        
                        Button {
                            if canEdit {
                                journalVM.currentIndex = index
                                
                                if isPresentedAsSheet {
                                    dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        navPath.append("QuestionJournal")
                                    }
                                } else {
                                    navPath.removeLast()
                                }
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(question.text)
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            if !isPresentedAsSheet {
                                                Image(systemName: "pencil")
                                                    .foregroundColor(.gray.opacity(0.5))
                                            }
                                        }
                                    )
                                
                                Text(question.answer.isEmpty ? "No thoughts provided." : question.answer)
                                    .font(.system(size: 20))
                                    .bold()
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(25)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.themeCard)
                            )
                            .padding(.horizontal, 25)
                        }
                        .buttonStyle(.plain)
                        .disabled(!canEdit)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle(isPresentedAsSheet ? "Initial Thoughts" : "Review Journal")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isPresentedAsSheet {
                    Button("Close") { dismiss() }
                } else {
                    Button {
                        // 1. COMBINE THE JOURNAL ANSWERS INTO THE ITEM
                        journalVM.lockInJournalAnswers()
                        
                        // 2. NOW WE PERMANENTLY SAVE IT TO SWIFTDATA!
                        if let finalItemToSave = journalVM.activeItem {
                            modelContext.insert(finalItemToSave)
                        }
                        
                        // 3. WIPE THE JOURNAL CLEAN FOR THE NEXT TIME
                        journalVM.resetJournal()
                        
                        // 4. POP ALL THE WAY BACK TO DASHBOARD
                        navPath.removeLast(navPath.count)
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(Color.themePrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewJournalView(navPath: .constant(NavigationPath()))
        .environmentObject(JournalViewModel())
}
