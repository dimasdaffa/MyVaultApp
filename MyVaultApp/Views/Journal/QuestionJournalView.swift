//
//  FirstPageView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct QuestionJournalView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var currentAnswer: String = ""
    
    var body: some View {
        VStack{
            ProgressBarView()
            VStack(spacing: 20){
                HStack(alignment: .lastTextBaseline,spacing: 0){
                    Text("\(viewModel.currentProgress)/")
                        .font(.system(size: 70))
                        .bold()
                        .foregroundStyle(viewModel.isLastQuestion ? Color.themePrimary : Color.black)
                    
                    Text("\(viewModel.totalQuestions)")
                        .font(.system(size: 44))
                        .bold()
                        .foregroundStyle(Color.themePrimary)
                    Spacer()
                }
                .padding(.horizontal, 43)
                .padding(.top,33)
                
                HStack{
                    Text(viewModel.questions[viewModel.currentIndex].text)
                        .font(.system(size: 27))
                        .animation(.easeInOut, value: viewModel.currentIndex)
                    Spacer()
                }
                .padding(.horizontal, 44)
                Spacer()
                
                VStack{
                    TextField("Express your thoughts here...",
                              text: $currentAnswer,
                              axis: .vertical
                    )
                    .lineLimit(1...6)
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
        .onAppear {
                    currentAnswer = viewModel.questions[viewModel.currentIndex].answer
                }
        .navigationTitle("Journal")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if viewModel.isLastQuestion {
                        // pindah halaman jika sudah pertanyaan terakhir
                        navPath.append("ReviewJournal")
                    } else {
                        // jika belum, ganti ke pertanyaan selanjutnya
                        withAnimation(.spring()) {
                            viewModel.nextQuestion()
                            currentAnswer = viewModel.questions[viewModel.currentIndex].answer
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.isLastQuestion ? "Finish" : "Next")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .disabled(currentAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
}


#Preview {
    QuestionJournalView(navPath: .constant(NavigationPath()))
        .environmentObject(JournalViewModel())
}
