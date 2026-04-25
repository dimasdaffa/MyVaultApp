//
//  NoBuyResultView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import SwiftUI

struct NoBuyResultView: View {
    @Binding var navPath: NavigationPath
    
    var body: some View {
        VStack{
            Image(systemName: "lock.shield.fill")
                .foregroundColor(Color.themePrimary)
                .font(.system(size: 203))
            
            VStack(spacing: 15){
                Text("CRISIS AVERTED, HANDOKO!")
                    .font(.system(size: 15))
                    .bold()
                
                VStack(alignment: .center, spacing: -10){
                    Text("Money stays")
                        .font(.system(size: 45))
                        .bold()
                    HStack{
                        Text("in")
                            .font(.system(size: 45))
                            .bold()
                        Text("Vault!")
                            .foregroundColor(Color.themePrimary)
                            .font(.system(size: 45))
                            .bold()
                    }
                }
                
                HStack{
                    Image(systemName: "hand.raised.fill")
                    Text("Impulse Restrained")
                        .font(.system(size: 15))
                        .bold()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 42)
                        .fill(Color.themeCard)
                )
            }
            Spacer()
            
            HStack{
                Image(systemName: "banknote.fill")
                    .font(.system(size: 57))
                    .foregroundStyle(Color.themeBackground)
                VStack(alignment: .leading, spacing: 5){
                    Text("SAVINGS PROTECTED")
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    Text("Purchase denied. Your future self will thank you for this.")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.themeBackground)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 42)
                    .fill(Color.themeBlack)
            )
            .padding(.horizontal, 25)
            
            Button {
                navPath.removeLast(navPath.count)
            } label: {
                Text("BACK TO VAULT")
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
    NoBuyResultView(navPath: .constant(NavigationPath()))
}
