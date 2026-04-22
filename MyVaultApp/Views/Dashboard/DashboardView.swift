//
//  DashboardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        NavigationStack {
            VStack () {
                HStack {
                    Text("MyVault")
                        .font(Font.largeTitle)
                        .bold()
                    Spacer()
                    
                    //                    Button(action: {
                    //                    }) {
                    //                        Image(systemName: "plus")
                    //                            .font(.title2)
                    //                            .fontWeight(.bold)
                    //                            .foregroundColor(.white)
                    //                            .frame(width: 56, height: 56)
                    //                            .background(Color.themePrimary)
                    //                            .glassEffect()
                    //                            .tint(Color.themePrimary)
                    //                            .shadow(color: Color.themePrimary.opacity(1), radius: 10, x: 0, y: 5)
                    //                            .clipShape(Circle())
                    //                    }
                    NavigationLink {
                        CreateItemView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.themePrimary)
                            .glassEffect()
                            .tint(Color.themePrimary)
                            .shadow(color: Color.themePrimary.opacity(1), radius: 10, x: 0, y: 5)
                            .clipShape(Circle())
                    }
                }
                .padding(20)
                
                CardView()
                    .padding(.top, 16)
                Spacer()
            }
            .background(Color.themeBackground)
        }
    }
}

#Preview {
    DashboardView()
}
