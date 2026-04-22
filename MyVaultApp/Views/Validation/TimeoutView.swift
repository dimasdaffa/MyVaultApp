//
//  TimeoutView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct TimeoutView: View {
    enum Currency {
        case rm
        case idr
        case usd
    }
    
    @State private var selectedCurrency: Currency = .idr
    @State private var text = ""
    
    var body: some View {

            VStack () {
                HStack(){
                    VStack(alignment: .leading, spacing: -15){
                        HStack{
                            Text("Time")
                                .font(.system(size: 45))
                                .bold()
                            Text("Out.")
                                .font(.system(size: 45))
                                .bold()
                                .foregroundColor(Color.themePrimary)
                        }
                       
                        
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, 31)
                HStack(){
                    VStack(alignment: .leading){
                        Text("Review your mood and your bank")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("account one last time before")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("making the call.")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, 31)
                
                VStack {
                    HStack {
                        Text("PRODUCT TITLE")
                            .font(.system(size: 15))
                            .bold()
                        Spacer()
                    }
                    TextField("New Balance 740", text: $text)
                        .padding(19)
                        .background(Color.themeCard)
                        .cornerRadius(42)
                }
                .padding(.top, 14)
                .padding(.horizontal, 31)
                
                VStack {
                    HStack {
                        Text("PRICE")
                            .font(.system(size: 15))
                            .bold()
                        Spacer()
                        Text("CURRENCY")
                            .font(.system(size: 15))
                            .bold()
                            .offset(x: -45)
                    }
                    HStack{
                        HStack{
                            Image(systemName: "dollarsign")
                                .font(.system(size: 20))
                            TextField("1.740.000", text: $text)
                        }
                        .frame(maxWidth: 400)
                        .padding(19)
                        .background(Color.themeCard)
                        .cornerRadius(42)
                        HStack{
                            Picker("Currency", selection: $selectedCurrency) {
                                Text("RM")
                                    .tag(Currency.rm)
                                
                                Text("IDR")
                                    .tag(Currency.idr)
                                
                                Text("USD")
                                    .tag(Currency.usd)
                            }
                        }
                        .frame(maxWidth: 100)
                        .padding(19)
                        .background(Color.themeCard)
                        .cornerRadius(42)
                    }
                }
                .padding(.top, 14)
                .padding(.horizontal, 31)
                
                VStack {
                    HStack {
                        Text("SOURCE LINK")
                            .font(.system(size: 15))
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Image(systemName: "link")
                            .font(.system(size: 20))
                        TextField("http://foot.com/nb740", text: $text)
                        
                    }
                    .padding(19)
                    .background(Color.themeCard)
                    .cornerRadius(42)
                    
                }
                .padding(.top, 14)
                .padding(.horizontal, 31)
            }
            Spacer()
            VStack{
                Text("REMAINING DURATION")
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                HStack(spacing: 0){
                    Text("00:")
                        .font(.system(size: 58))
                        .foregroundStyle(Color.themeBackground)
                    Text("00")
                        .font(.system(size: 58))
                        .foregroundStyle(Color.themeRed.opacity(0.75))
                    Text(":00")
                        .font(.system(size: 58))
                        .foregroundStyle(Color.themeBackground)
                }
            }
            .padding(30)
            .padding(.horizontal,25)
            .background(
                RoundedRectangle(cornerRadius: 42)
                    .fill(Color.themeBlack)
            )
            
            NavigationLink {
                EmotionQuestionView()
            } label: {
                Text("Validate Answer")
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

        .navigationTitle("Validation")
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    TimeoutView()
}
