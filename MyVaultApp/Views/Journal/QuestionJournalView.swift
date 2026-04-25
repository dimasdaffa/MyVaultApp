//
//  FirstPageView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct QuestionJournalView: View {
    @Binding var navPath: NavigationPath
    @State private var emotionText: String = ""
    
    var body: some View {
        VStack{
                ProgressBarView()
                VStack(spacing: 20){
                    HStack(alignment: .lastTextBaseline,spacing: 0){
                        Text("2/")
                            .font(.system(size: 70))
                            .bold()
                        Text("8")
                            .font(.system(size: 44))
                            .bold()
                            .foregroundStyle(Color.themePrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 43)
                    .padding(.top,33)
                    
                    HStack{
                        Text("Is it something I will use \nregularly?")
                            .font(.system(size: 27))
                        Spacer()
                    }
                    .padding(.horizontal, 44)
                    Spacer()
                    
                    VStack{
                        TextField("Express your emotion here...", text: $emotionText)
                            .font(.system(size: 20))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                    }
                    .padding(.horizontal, 44)
                    .offset(y: -50)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 42)
                        .fill(Color.themeCard)
                        .padding(.top,12)
                        .padding(.horizontal,25)
                )
            }
            .padding(.bottom, -10)
        
        .navigationTitle("Journal")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navPath.append("ReviewJournal")
                } label: {
                    HStack(spacing: 4) {
                        Text("Next")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
}


#Preview {
    QuestionJournalView(navPath: .constant(NavigationPath()))
}
