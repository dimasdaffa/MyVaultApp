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
                                journalVM.startEditing(at: index)
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
                        HapticManager.shared.notification(type: .success)
                        // COMBINE THE JOURNAL ANSWERS INTO THE ITEM
                        journalVM.lockInJournalAnswers()
                        
                        if let finalItemToSave = journalVM.activeItem {
                            // Only insert into SwiftData if it's a BRAND NEW item.
                            // If it's an existing item being edited, SwiftData auto-saves it automatically
                            if finalItemToSave.modelContext == nil {
                                // START THE TIMER NOW — cooldown begins from confirm, not from "START"
                                // Di production, kita set cooling down menjadi 24 jam (86400 detik)
                                finalItemToSave.targetDate = Date().addingTimeInterval(60)
                                modelContext.insert(finalItemToSave)
                            }
                        }
                        
                        // WIPE THE JOURNAL CLEAN FOR THE NEXT TIME
                        journalVM.resetJournal()
                        
                        // POP ALL THE WAY BACK TO DASHBOARD
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
        .sheet(item: $journalVM.editingItem) { item in
            NavigationStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text(journalVM.questions[item.index].text)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    
                    TextEditor(text: $journalVM.draftAnswer)
                        .padding(15)
                        .background(Color.themeCard)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    Spacer()
                }
                .padding(25)
                .navigationTitle("Edit Observation")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            journalVM.cancelEdit()
                        }
                        .foregroundColor(.gray)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            journalVM.saveEdit()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(Color.themePrimary)
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ReviewJournalView(navPath: .constant(NavigationPath()))
        .environmentObject(JournalViewModel())
}
