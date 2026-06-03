//
//  CreateItemView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI
import SwiftData

struct CreateItemView: View {
    @Binding var navPath: NavigationPath
    
    @EnvironmentObject var journalVM: JournalViewModel
    @Environment(\.hapticProvider) private var hapticProvider
    @StateObject private var viewModel = CreateItemViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack() {
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
                            Text("Let's see if this is a 'need' or just a 'now'")
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
                        TextField("What's catching your eye?", text: $viewModel.itemTitle)
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
                                TextField("0", text: $viewModel.itemPrice)
                                    .keyboardType(.numberPad)
                                    .onChange(of: viewModel.itemPrice) { oldValue, newValue in
                                        viewModel.onPriceChanged(newValue)
                                    }
                                    .onChange(of: viewModel.selectedCurrency) { oldValue, newValue in
                                        viewModel.onCurrencyChanged()
                                    }
                            }
                            .frame(maxWidth: 400)
                            .padding(19)
                            .background(Color.themeCard)
                            .cornerRadius(42)
                            
                            HStack{
                                Picker("Currency", selection: $viewModel.selectedCurrency) {
                                    ForEach(Currency.allCases) { currency in
                                        Text(currency.rawValue)
                                            .tag(currency)
                                    }
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
                            TextField("http://...", text: $viewModel.itemLink)
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
                
                Button{
                    if viewModel.prepareItem(journalVM: journalVM) != nil {
                        hapticProvider.notification(type: .success)
                        navPath.append("FirstPage")
                    }
                } label: {
                    Text("START")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 350, height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(viewModel.isFormValid ? Color.themePrimary : Color.gray.opacity(0.3))
                        )
                        .shadow(color: viewModel.isFormValid ? Color.themePrimary.opacity(1) : Color.clear, radius: 10, x: 0, y: 5)
                }
                .disabled(!viewModel.isFormValid)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationTitle("New Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    CreateItemView(navPath: .constant(NavigationPath()))
        .modelContainer(for: VaultItem.self, inMemory: true)
        .environmentObject(JournalViewModel())
}
