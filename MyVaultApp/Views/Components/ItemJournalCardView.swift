//
//  ItemJournalCardView.swift
//  MyVaultApp
//

import SwiftUI

struct ItemJournalCardView: View {
    var item: VaultItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(item.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color.themePrimary)
            
            HStack(spacing: 12) {
                Image(systemName: "banknote")
                    .font(.system(size: 22))
                Text("\(item.currency) \(item.price)")
                    .font(.system(size: 24))
            }
            
            if !item.link.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "link")
                        .font(.system(size: 22))
                    Text(item.link)
                        .font(.system(size: 24))
                        .foregroundColor(Color.themePrimary)
                        .underline()
                        .lineLimit(1)
                }
            }
        }
        .padding(25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.themeCard)
        )
        .padding(.horizontal, 25)
    }
}

#Preview {
    ItemJournalCardView(item: VaultItem(name: "Sony WH-1000XM5", price: "5.000.000", currency: "IDR", link: "https://sony.com",targetDate: Date().addingTimeInterval(172800)))
}
