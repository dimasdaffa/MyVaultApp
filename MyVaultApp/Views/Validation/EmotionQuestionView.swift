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
    @EnvironmentObject var viewModel: ValidationViewModel
    
    let emotionOptions = [
        ("Very Strongly", 5),
        ("Strongly", 4),
        ("Moderately", 3),
        ("Little", 2),
        ("Least", 1)
    ]
    
    var body: some View {
        
        VStack{
            ProgressBarView()
            VStack(spacing: 20){
                HStack(alignment: .lastTextBaseline,spacing: 0){
                    Text("\(viewModel.currentTotalProgress)/")
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
                    Text(viewModel.emotionQuestions[viewModel.currentEmotionIndex].text)
                        .font(.system(size: 27))
                        .animation(.easeInOut, value: viewModel.currentEmotionIndex)
                    Spacer()
                }
                .padding(.horizontal, 44)
                Spacer()
                
                VStack(spacing: 15){
                    ForEach(emotionOptions, id: \.0) { option in
                        Button(action: {
                            viewModel.emotionQuestions[viewModel.currentEmotionIndex].score = option.1
                        }) {
                            Text(option.0)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(viewModel.emotionQuestions[viewModel.currentEmotionIndex].score == option.1 ? Color.themePrimary : Color.gray.opacity(0.5))
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
                    // Jika pertanyaan ke-12 (index 11), pindah ke halaman Finansial
                    if viewModel.currentEmotionIndex == 11 {
                        navPath.append("FinanceQuestion")
                    } else {
                        // Jika belum, lanjut pertanyaan emosi berikutnya
                        withAnimation(.spring()) {
                            viewModel.nextEmotionQuestion()
                        }
                    }
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
                // Matikan tombol NEXT jika user belum memilih skala
                .disabled(viewModel.emotionQuestions[viewModel.currentEmotionIndex].score == nil)
            }
        }
    }
}

#Preview {
    EmotionQuestionView(navPath: .constant(NavigationPath()))
        .environmentObject(ValidationViewModel())
}
