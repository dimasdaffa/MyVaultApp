//
//  JournalView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct CreateItemView: View {
    enum Currency {
        case rm
        case idr
        case usd
    }
    
    @Binding var navPath: NavigationPath
    @State private var selectedCurrency: Currency = .idr
    @State private var itemTitle: String = ""
    @State private var itemPrice: String = ""
    @State private var itemLink: String = ""
    
    var body: some View {
        VStack{
            VStack () {
                HStack(){
                    VStack(alignment: .leading, spacing: -15){
                        Text("Hold That")
                            .font(.system(size: 45))
                            .bold()
                        Text("Thought.")
                            .font(.system(size: 45))
                            .bold()
                            .foregroundColor(Color.themePrimary)
                        
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, 31)
                HStack(){
                    VStack(alignment: .leading){
                        Text("Give your wallet a breather.")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("Let’s see if this is a ‘need’ or just a ‘now’")
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
                    TextField("What's catching your eye?", text: $itemTitle)
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
                            TextField("0", text: $itemPrice)
                                .keyboardType(.numberPad)
                                .onChange(of: itemPrice) { newValue in
                                    // Format number
                                    itemPrice = formatCurrency(newValue, currency: selectedCurrency)
                                }
                                .onChange(of: selectedCurrency) { _ in
                                    // Reformat when user change currency
                                    itemPrice = formatCurrency(itemPrice, currency: selectedCurrency)
                                }
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
                        TextField("http://...", text: $itemLink)
                        
                    }
                    .padding(19)
                    .background(Color.themeCard)
                    .cornerRadius(42)
                    
                }
                .padding(.top, 14)
                .padding(.horizontal, 31)
            }
            Spacer()
            
            Button{
                navPath.append("FirstPage")
            } label: {
                Text("START")
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
        .navigationTitle("New Entry")
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func formatCurrency(_ value: String, currency: Currency) -> String {
        let numbersOnly = value.filter { "0123456789".contains($0) }
        guard let number = Int(numbersOnly) else { return "" }
        
        // 2. Format sesuai mata uang
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        switch currency {
        case .idr:
            formatter.groupingSeparator = "." // IDR
        case .usd, .rm:
            formatter.groupingSeparator = "," // USD/RM
        }
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}



#Preview {
    CreateItemView(navPath: .constant(NavigationPath()))
}
