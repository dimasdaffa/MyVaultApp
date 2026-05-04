//
//  FinanceQuestionView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 22/04/26.
//

import SwiftUI

struct FinanceQuestionView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var validationVM: ValidationViewModel
    
    var body: some View {
        
        VStack{
            ProgressBarView(
                currentStep: 12 + (validationVM.currentFinanceIndex + 1),
                totalSteps: 14
            )
            VStack(spacing: 20){
                HStack(alignment: .lastTextBaseline,spacing: 0){
                    Text("\(12 + validationVM.currentFinanceIndex + 1)/")
                        .font(.system(size: 70))
                        .bold()
                        .foregroundStyle(validationVM.currentFinanceIndex == 1 ? Color.themePrimary : Color.black)
                    Text("14")
                        .font(.system(size: 44))
                        .bold()
                    Spacer()
                }
                .foregroundStyle(Color.themePrimary)
                .padding(.horizontal, 43)
                .padding(.top,33)
                
                HStack{
                    Text(validationVM.financeQuestions[validationVM.currentFinanceIndex].text)
                        .font(.system(size: 27))
                        .animation(.easeInOut, value: validationVM.currentFinanceIndex)
                    Spacer()
                }
                .padding(.horizontal, 44)
                Spacer()
                
                VStack(spacing: 15){
                    ForEach(QuestionsData.financeOptions) { option in
                        Button(action: {
                            validationVM.financeQuestions[validationVM.currentFinanceIndex].answer = option.value
                        }) {
                            Text(option.value)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(validationVM.financeQuestions[validationVM.currentFinanceIndex].answer == option.value ? Color.themePrimary : Color.gray.opacity(0.5))
                    }
                }
                .foregroundColor(Color.themeBackground)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, 50)
                Spacer()
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Check if we are on the very last Finance question
                    if validationVM.currentFinanceIndex == validationVM.financeQuestions.count - 1 {
                        
                        let isApprovedToBuy = validationVM.finalizeValidation()
                        
                        if isApprovedToBuy {
                            navPath.append("BuyResult")
                        } else {
                            navPath.append("NoBuyResult")
                        }
                        
                    } else {
                        // If not the last question, just go to the next one
                        withAnimation(.spring()) {
                            validationVM.nextFinanceQuestion()
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        // Change text to "Finish" if it's the last question
                        Text(validationVM.currentFinanceIndex == validationVM.financeQuestions.count - 1 ? "Finish" : "Next")
                            .fontWeight(.semibold)
                        
                        // Only show the chevron arrow if it's NOT the last question
                        if validationVM.currentFinanceIndex < validationVM.financeQuestions.count - 1 {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                // Disable button if no answer is selected
                .disabled(validationVM.financeQuestions[validationVM.currentFinanceIndex].answer?.isEmpty ?? true)
            }
        }
        
    }
}

#Preview {
    FinanceQuestionView(navPath: .constant(NavigationPath()))
        .environmentObject(ValidationViewModel())
}
