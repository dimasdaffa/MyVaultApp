//
//  ReviewJournalView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct ReviewJournalView: View {
    
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
                    
                    VStack(spacing:70){
                        JournalCardView()
                        JournalCardView()
                        JournalCardView()
                        JournalCardView()
                        JournalCardView()
                        JournalCardView()
                        JournalCardView()
                        JournalCardView()
                    }
                    
                }
                .padding(.top)
            }

        .navigationTitle("Review Journal")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    DashboardView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16))
                        .clipShape(Circle())
                }
            }        }
        
    }
}

#Preview {
    ReviewJournalView()
}
