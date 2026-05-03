//
//  FinanceQuestionView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 22/04/26.
//

import SwiftUI

struct FinanceQuestionView: View {
    @Binding var navPath: NavigationPath
    @State private var answer: String = ""
    @EnvironmentObject var validationVM: ValidationViewModel
    
    var body: some View {
        
        VStack{
            ProgressBarView(
                currentStep: 12 + (validationVM.currentFinanceIndex + 1),
                totalSteps: 14
            )
            VStack(spacing: 20){
                HStack(alignment: .lastTextBaseline,spacing: 0){
                    Text("\(validationVM.currentTotalProgress)/")
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
                    ForEach(["Yes", "No"], id: \.self) { option in
                        Button(action: {
                            // Simpan jawaban "Yes" atau "No"
                            validationVM.financeQuestions[validationVM.currentFinanceIndex].answer = option
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(validationVM.financeQuestions[validationVM.currentFinanceIndex].answer == option ? Color.themePrimary : Color.gray.opacity(0.5))
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
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // LOGIKA RESULT
                    if validationVM.currentFinanceIndex == 1 {
                        // Jika sudah pertanyaan terakhir (Q2), lempar ke Result
                        if validationVM.finalDecisionIsBuy {
                            navPath.append("BuyResult")
                        } else {
                            navPath.append("NoBuyResult")
                        }
                    } else {
                        // Jika masih Q1, lanjut ke Q2
                        withAnimation(.spring()) {
                            validationVM.nextFinanceQuestion()
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(validationVM.currentFinanceIndex == 1 ? "Finish" : "Next")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                // Matikan tombol NEXT jika belum dijawab
                .disabled(validationVM.financeQuestions[validationVM.currentFinanceIndex].answer == nil)
            }
        }
        
    }
}

#Preview {
    FinanceQuestionView(navPath: .constant(NavigationPath()))
        .environmentObject(ValidationViewModel())
}
