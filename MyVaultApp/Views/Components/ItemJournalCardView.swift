//
//  ItemJournalCardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct ItemJournalCardView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 15){
            Text("New Balance 740")
                .font(.system(size: 35))
                .bold()
                .foregroundColor(Color.themePrimary)
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "banknote.fill")
                    Text("IDR 1.740.000")
                }
                HStack{
                    Image(systemName: "link")
                    Text("http://foot.com/nb740")
                        .underline()
                }
            }
            .font(.system(size: 27))
        }
        .background(
            RoundedRectangle(cornerRadius: 42)
                .fill(Color.themeCard)
                .padding(-25)
            
        )
//        .padding(.horizontal,50)
    }
}

#Preview {
    ItemJournalCardView()
}
