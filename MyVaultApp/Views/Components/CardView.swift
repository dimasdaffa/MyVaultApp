//
//  CardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI

struct SolidPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.1 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CardView: View {
    @Binding var navPath: NavigationPath
    var itemsForUI: [VaultItem?]
    @ObservedObject var viewModel: DashboardViewModel
    @State private var cardsDealt: Bool = false
    
    var body: some View {
        VStack(spacing: -170) {
            
            // 2. Loop through the exactly 3 slots
            ForEach(Array(itemsForUI.enumerated()), id: \.offset) { index, item in
                
                let isTop = (index == 0)
                let bgColor = isTop ? Color.themeBackground : (index == 1 ? Color.themePrimary : Color.themeBlack)
                let textColor = isTop ? Color.themeBlack : Color.white
                let paddingTop: CGFloat = isTop ? 40 : 190
                
                Button {
                    // If it's nil (Empty Slot), go to Create
                    if item == nil {
                        navPath.append("CreateItem")
                    } else if let realItem = item {
                        // INSTEAD OF A STRING, WE PASS THE ENTIRE ITEM
                        navPath.append(realItem)
                    }
                } label: {
                    VStack {
                        if let validItem = item {
                            // --- ACTIVE / FINISHED SLOT UI ---
                            Text(validItem.name)
                                .font(.system(size: 36))
                                .bold()
                                .foregroundStyle(textColor)
                                .lineLimit(1)
                            
                            HStack(alignment: .lastTextBaseline, spacing: 0){
                                Image(systemName: "timer").font(.system(size: 20)).opacity(0)
                                Spacer()
                                
                                let time = viewModel.timeRemaining(for: validItem)
                                
                                if time == 0 {
                                    Text("00:").font(.system(size: 47)).foregroundStyle(textColor).monospacedDigit()
                                    Text("00").font(.system(size: 47)).foregroundStyle(Color.themeRed.opacity(0.85)).monospacedDigit()
                                    Text(":00").font(.system(size: 47)).foregroundStyle(textColor).monospacedDigit()
                                    Spacer()
                                    Image(systemName: "clock.badge.exclamationmark").font(.system(size: 20)).foregroundStyle(Color.themeRed.opacity(0.85))
                                } else {
                                    let t = viewModel.formatTime(time)
                                    Text(t.h).font(.system(size: 52)).foregroundStyle(textColor).monospacedDigit()
                                    Text(":\(t.m):\(t.s)").font(.system(size: 27)).foregroundStyle(textColor).monospacedDigit()
                                    Spacer()
                                    Image(systemName: "timer").font(.system(size: 20)).foregroundStyle(textColor)
                                }
                            }
                            .padding(.horizontal, 15)
                            
                        } else {
                            // --- EMPTY SLOT UI ---
                            Text("Space for reflection.")
                                .font(.system(size: 24))
                                .fontWeight(.light)
                                .italic()
                                .foregroundStyle(textColor.opacity(0.5))
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .padding(.top, 20)
                        }
                    }
                    .padding(.top, paddingTop)
                    .padding(.bottom, 10)
                    .background(UnevenRoundedRectangle(bottomLeadingRadius: 123).fill(bgColor))
                }
                .buttonStyle(SolidPressButtonStyle())
                .offset(y: cardsDealt ? 0 : -600)
                .animation(
                    .spring(response: 0.95, dampingFraction: 1)
                        .delay(Double(index) * 0.15),
                    value: cardsDealt
                )
                .zIndex(Double(3 - index))
            }
        }
        .clipped()
        .onAppear {
            cardsDealt = true
        }
    }
}


// MARK: - Previews

#Preview("Empty Cards") {
    CardView(
        navPath: .constant(NavigationPath()),
        itemsForUI: [nil, nil, nil],
        viewModel: DashboardViewModel()
    )
    .background(Color.themeBackground)
}

#Preview("Populated Cards") {
    let vm = DashboardViewModel()
    
    // Item 1: Actively cooling down (24h left)
    let mock1 = VaultItem(name: "Apple Vision Pro", price: "60.000.000", targetDate: Date().addingTimeInterval(86400))
    mock1.currency = "IDR"
    
    // Item 2: Timer finished (1 hour ago)
    let mock2 = VaultItem(name: "New Balance 990v6", price: "4.500.000", targetDate: Date().addingTimeInterval(-3600))
    mock2.currency = "IDR"
    
    return CardView(
        navPath: .constant(NavigationPath()),
        itemsForUI: [nil, mock1, mock2],
        viewModel: vm
    )
    .background(Color.themeBackground)
}
