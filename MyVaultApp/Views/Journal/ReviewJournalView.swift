//
//  ReviewJournalView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct ReviewJournalView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var journalVM: JournalViewModel
    @Environment(\.dismiss) var dismiss
    
    var isPresentedAsSheet: Bool = false
    
    var body: some View {
        
        ScrollView{
            VStack(spacing: 35){
                ItemJournalCardView()
                HStack{
                    Text("Observations")
                        .font(.system(size: 28))
                        .bold()
                    Spacer()
                    Text("8 Entries")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
                .padding(.horizontal,30)
                
                VStack(spacing: 20) {
                    ForEach(journalVM.questions, id: \.text) { question in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(question.text)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            
                            Text(question.answer.isEmpty ? "No thoughts provided." : question.answer)
                                .font(.system(size: 20))
                                .bold()
                        }
                        .padding(25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.themeCard)
                        )
                        .padding(.horizontal, 25)
                    }
                }
            }
            .padding(.top)
        }
        
        .navigationTitle("Review Journal")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isPresentedAsSheet {
                    Button("Close") { dismiss() }
                } else {
                    Button {
                        navPath.removeLast(navPath.count) 
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16))
                            .clipShape(Circle())
                    }
                }
            }   }
        
    }
}

#Preview {
    ReviewJournalView(navPath: .constant(NavigationPath()))
        .environmentObject(JournalViewModel())
}
