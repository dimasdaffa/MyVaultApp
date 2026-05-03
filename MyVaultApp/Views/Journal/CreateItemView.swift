//
//  CreateItemView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI
import SwiftData

struct CreateItemView: View {
    enum Currency {
        case rm
        case idr
        case usd
    }
    
    @Binding var navPath: NavigationPath
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journalVM: JournalViewModel
    
    @State private var selectedCurrency: Currency = .idr
    @State private var itemTitle: String = ""
    @State private var itemPrice: String = ""
    @State private var itemLink: String = ""
    
    // Form is only valid if BOTH Title and Price are filled out
    var isFormValid: Bool {
        let isTitleValid = !itemTitle.trimmingCharacters(in: .whitespaces).isEmpty
        let isPriceValid = !itemPrice.trimmingCharacters(in: .whitespaces).isEmpty && itemPrice != "0"
        return isTitleValid && isPriceValid
    }
    
    var body: some View {
        VStack {
            VStack () {
                HStack() {
                    VStack(alignment: .leading, spacing: -15) {
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
                
                HStack() {
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
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        
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
                saveItem()
            } label: {
                Text("START")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(width: 350, height: 62)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(isFormValid ? Color.themePrimary : Color.gray.opacity(0.3))
                    )
                    .glassEffect()
                    .shadow(color: isFormValid ? Color.themePrimary.opacity(1) : Color.clear, radius: 10, x: 0, y: 5)
            }
            .disabled(!isFormValid)
            .background(Color.themeBackground)
        }
        .navigationTitle("New Entry")
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func saveItem() {
        let target = Date().addingTimeInterval(172800)
        let currencyString = String(describing: selectedCurrency).uppercased()
        
        let newItem = VaultItem(
            name: itemTitle,
            price: itemPrice,
            currency: currencyString,
            link: itemLink,
            targetDate: target
        )
        
        // 1. Save it to the iPhone's hard drive
        modelContext.insert(newItem)
        
        // 2. TODO in next step: Tell the JournalViewModel WHICH item we are journaling about right now.
        // journalVM.activeItem = newItem
        
        // 3. Force the user into the Journal Questions!
        navPath.append("FirstPage")
    }
    
    private func formatCurrency(_ value: String, currency: Currency) -> String {
        let numbersOnly = value.filter { "0123456789".contains($0) }
        guard let number = Int(numbersOnly) else { return "" }
        
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
        .modelContainer(for: VaultItem.self, inMemory: true)
        .environmentObject(JournalViewModel())
}
