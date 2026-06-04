//
//  QuestionJournalView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct QuestionJournalView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var showExitAlert = false
    
    // We use a custom binding to read/write directly to the ViewModel's array
    private var currentAnswerBinding: Binding<String> {
        Binding<String>(
            get: { viewModel.questions[viewModel.currentIndex].answer },
            set: { viewModel.questions[viewModel.currentIndex].answer = $0 }
        )
    }
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            VStack{
                ProgressBarView(currentStep: viewModel.currentProgress, totalSteps: viewModel.totalQuestions)
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
                    .padding(.horizontal, 44)
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
                                  text: currentAnswerBinding, // BIND DIRECTLY TO VIEWMODEL
                                  axis: .vertical
                        )
                        .lineLimit(4...8)
                        .font(.system(size: 18))
                        .padding(20)
                        .background(Color.themeBackground)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 44)
                    .offset(y: -30)
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
        }
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if viewModel.currentIndex == 0 {
                        showExitAlert = true
                    } else {
                        withAnimation(.spring()) {
                            viewModel.previousQuestion()
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if viewModel.isLastQuestion {
                        // 1. SAVE THE DATA
                        viewModel.lockInJournalAnswers()
            
                        navPath.append("ReviewJournal")
                    } else {
                        // Jika belum, ganti ke pertanyaan selanjutnya
                        withAnimation(.spring()) {
                            viewModel.nextQuestion()
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.isLastQuestion ? "Finish" : "Next")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                // Disable button if current answer is empty
                .disabled(currentAnswerBinding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .alert("Discard this entry?", isPresented: $showExitAlert) {
            Button("Keep Editing", role: .cancel) {}
            Button("Discard", role: .destructive) {
                viewModel.resetJournal()
                if !navPath.isEmpty {
                    navPath.removeLast()
                }
            }
        } message: {
            Text("Your journal answers will not be saved.")
        }
    }
}

#Preview {
    QuestionJournalView(navPath: .constant(NavigationPath()))
        .environmentObject(JournalViewModel())
}
