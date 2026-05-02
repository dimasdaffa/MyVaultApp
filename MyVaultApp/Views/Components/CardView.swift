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
    @ObservedObject var viewModel: DashboardViewModel 
    
    var body: some View {
        VStack(spacing: -150) {
            
            ForEach(Array(viewModel.sortedItems.enumerated()), id: \.element.id) { index, item in
                
                let isTop = (index == 0)
                let bgColor = isTop ? Color.themeBackground : (index == 1 ? Color.themePrimary : Color.themeBlack)
                let textColor = isTop ? Color.themeBlack : Color.white
                let paddingTop: CGFloat = isTop ? 40 : 170
                
                Button {
                    if item.isEmpty {
                        navPath.append("CreateItem")
                    } else {
                        navPath.append(item.timeRemaining == 0 ? "Timeout_Ready" : "Timeout_Waiting")
                    }
                } label: {
                    VStack {
                        if item.isEmpty {
                            Text("Space for reflection.")
                                .font(.system(size: 24))
                                .fontWeight(.light)
                                .italic()
                                .foregroundStyle(textColor.opacity(0.5))
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .padding(.top, 20)
                        } else {
                            Text(item.name)
                                .font(.system(size: 36))
                                .bold()
                                .foregroundStyle(textColor)
                                .lineLimit(1)
                            
                            HStack(alignment: .lastTextBaseline, spacing: 0){
                                Image(systemName: "timer").font(.system(size: 20)).opacity(0)
                                Spacer()
                                
                                if item.timeRemaining == 0 {
                                    Text("00:").font(.system(size: 47)).foregroundStyle(textColor).monospacedDigit()
                                    Text("00").font(.system(size: 47)).foregroundStyle(Color.themeRed.opacity(0.85)).monospacedDigit()
                                    Text(":00").font(.system(size: 47)).foregroundStyle(textColor).monospacedDigit()
                                    Spacer()
                                    Image(systemName: "clock.badge.exclamationmark").font(.system(size: 20)).foregroundStyle(Color.themeRed.opacity(0.85))
                                } else {
                                    let t = viewModel.formatTime(item.timeRemaining) // USING VIEWMODEL FORMATTER
                                    Text(t.h).font(.system(size: 52)).foregroundStyle(textColor).monospacedDigit()
                                    Text(":\(t.m):\(t.s)").font(.system(size: 27)).foregroundStyle(textColor).monospacedDigit()
                                    Spacer()
                                    Image(systemName: "timer").font(.system(size: 20)).foregroundStyle(textColor)
                                }
                            }
                            .padding(.horizontal, 15)
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

#Preview {
    CardView(navPath: .constant(NavigationPath()), viewModel: DashboardViewModel())
}
