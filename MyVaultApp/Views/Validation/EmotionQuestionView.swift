//
//  EmotionQuestionView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 22/04/26.
//

import SwiftUI

struct EmotionQuestionView: View {
    @Binding var navPath: NavigationPath
    @State private var emotionText: String = ""
    
    var body: some View {

            VStack{
                ProgressBarView()
                VStack(spacing: 20){
                    HStack(alignment: .lastTextBaseline,spacing: 0){
                        Text("5/")
                            .font(.system(size: 70))
                            .bold()
                        Text("14")
                            .font(.system(size: 44))
                            .bold()
                            .foregroundStyle(Color.themePrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 43)
                    .padding(.top,33)
                    
                    HStack{
                        Text("I believe buying this will provide an instant mood boost.")
                            .font(.system(size: 27))
                        Spacer()
                    }
                    .padding(.horizontal, 44)
                    Spacer()
                    
                    VStack(spacing: 15){
                        ForEach(["Very Strongly", "Strongly", "Moderately", "Little", "Least"], id: \.self) { emotion in
                            Button(action: {
                                emotionText = emotion
                            }) {
                                Text(emotion)
                                    .frame(maxWidth: .infinity)
                            }
                            .tint(emotionText == emotion ? Color.themePrimary : Color.gray.opacity(0.5))
                        }
                    }
                    .foregroundColor(Color.themeBackground)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal, 50)
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

        
        .navigationTitle("Validation")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navPath.append("FinanceQuestion")
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
    EmotionQuestionView(navPath: .constant(NavigationPath()))
}
