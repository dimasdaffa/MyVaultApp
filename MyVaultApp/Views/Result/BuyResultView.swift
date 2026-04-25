//
//  SuccessResultView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 22/04/26.
//

import SwiftUI

struct BuyResultView: View {
    @Binding var navPath: NavigationPath
    
    var body: some View {
            VStack{
                Image(systemName: "medal.star.fill")
                    .foregroundColor(Color.themePrimary)
                    .font(.system(size: 203))
                VStack(spacing: 15){
                    Text("YOU'VE DONE THE WORK, HANDOKO!")
                        .font(.system(size: 15))
                        .bold()
                    VStack(alignment: .center, spacing: -10){
                        Text("You’re allowed")
                            .font(.system(size: 45))
                            .bold()
                        HStack{
                            Text("to")
                                .font(.system(size: 45))
                                .bold()
                            Text("Buy!")
                                .foregroundColor(Color.themePrimary)
                                .font(.system(size: 45))
                                .bold()
                        }
                        
                    }
                    HStack{
                        Image(systemName: "checkmark.shield.fill")
                        Text("Emotion & Finance Check")
                            .font(.system(size: 15))
                            .bold()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 42)                            .fill(Color.themeCard)
                        
                    )
                }
                Spacer()
                
                HStack{
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 57))
                        .foregroundStyle(Color.themeBackground)
                    VStack(alignment: .leading, spacing: 5){
                        Text("HEALTHY MARGIN")
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        Text("Budget approved. This purchase won’t mess up your goals.")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.themeBackground)
                    }
                }
                .padding(30)
                
                .background(
                    RoundedRectangle(cornerRadius: 42)
                        .fill(Color.themeBlack)
                )
                .padding(.horizontal,25)
                
                Button {
                    navPath.removeLast(navPath.count)
                } label:{
                    Text("FINISH")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 350, height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.themePrimary)
                        )
                        .glassEffect()
                        .shadow(color: Color.themePrimary.opacity(1), radius: 10, x: 0, y: 5)
                }
                .background(Color.themeBackground)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
            
    }
}

#Preview {
    BuyResultView(navPath: .constant(NavigationPath()))
}
