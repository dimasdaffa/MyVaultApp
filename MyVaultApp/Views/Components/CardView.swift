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
    
    var body: some View {
            VStack(spacing: -150) {
                
                // 2. Loop through the exactly 3 slots
                ForEach(Array(itemsForUI.enumerated()), id: \.offset) { index, item in
                    
                    let isTop = (index == 0)
                    let bgColor = isTop ? Color.themeBackground : (index == 1 ? Color.themePrimary : Color.themeBlack)
                    let textColor = isTop ? Color.themeBlack : Color.white
                    let paddingTop: CGFloat = isTop ? 40 : 170
                    
                    Button {
                        // If it's nil (Empty Slot), go to Create
                        if item == nil {
                            navPath.append("CreateItem")
                        } else if let realItem = item {
                            // If it's a real item, check its time
                            let time = viewModel.timeRemaining(for: realItem)
                            navPath.append(time == 0 ? "Timeout_Ready" : "Timeout_Waiting")
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
                    .zIndex(Double(3 - index))
                }
            }
        }
    }

    // 3. For the Preview to work, we just pass an empty array of 3 nils
    #Preview {
        CardView(navPath: .constant(NavigationPath()), itemsForUI: [nil, nil, nil], viewModel: DashboardViewModel())
    }
