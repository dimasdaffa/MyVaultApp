//
//  CardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI
import Combine

struct SolidPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.1 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// DATA MODEL FOR VAULT ITEMS
struct VaultItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var timeRemaining: TimeInterval
    var isEmpty: Bool
}

struct CardView: View {
    @Binding var navPath: NavigationPath
    @Binding var hasReadyItem: Bool
    
    // OUR DUMMY DATA
    @State private var items: [VaultItem] = [
        VaultItem(name: "New Balance 740", timeRemaining: 172763, isEmpty: false), // Active
        VaultItem(name: "Salomon XT", timeRemaining: 15, isEmpty: false),          // Watch this drop
        VaultItem(name: "", timeRemaining: 0, isEmpty: true)                       // Empty Slot
    ]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // LIKE GRAVITY SORTING
    var sortedItems: [VaultItem] {
        items.sorted { item1, item2 in
            // Sistem Skor: Makin kecil skor, makin di atas posisinya.
            func getScore(for item: VaultItem) -> Int {
                if item.isEmpty { return 0 }             // 0 = Paling Atas (Krem)
                if item.timeRemaining > 0 { return 1 }   // 1 = Tengah (Oranye)
                return 2                                 // 2 = Paling Bawah (Hitam)
            }
            return getScore(for: item1) < getScore(for: item2)
        }
    }
    
    func formatTime(_ totalSeconds: TimeInterval) -> (h: String, m: String, s: String) {
        let h = String(format: "%02d", Int(totalSeconds) / 3600)
        let m = String(format: "%02d", (Int(totalSeconds) % 3600) / 60)
        let s = String(format: "%02d", Int(totalSeconds) % 60)
        return (h, m, s)
    }
    
    var body: some View {
        VStack(spacing: -150) {
            
            ForEach(Array(sortedItems.enumerated()), id: \.element.id) { index, item in
                
                // Warnai berdasarkan posisi lapisan/index
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
                                    let t = formatTime(item.timeRemaining)
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
                .zIndex(Double(3 - index)) // Reverses Z-index so Top is 3, Middle is 2, Bottom is 1
            }
        }
        .onAppear {
            // Check immediately on load if anything is ready
            hasReadyItem = items.contains(where: { !$0.isEmpty && $0.timeRemaining == 0 })
        }
        .onReceive(timer) { _ in
            var foundReady = false
            
            // Tick all active timers down
            for i in 0..<items.count {
                if !items[i].isEmpty {
                    if items[i].timeRemaining > 0 {
                        if items[i].timeRemaining == 1 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                items[i].timeRemaining -= 1
                            }
                        } else {
                            items[i].timeRemaining -= 1
                        }
                    }
                    
                    // Note if any item is at 0
                    if items[i].timeRemaining == 0 {
                        foundReady = true
                    }
                }
            }
            
            // 2. UPDATE DASHBOARD IF THE STATUS CHANGED
            if hasReadyItem != foundReady {
                withAnimation(.easeInOut(duration: 0.3)) {
                    hasReadyItem = foundReady
                }
            }
        }
    }
    
}

#Preview {
    CardView(navPath: .constant(NavigationPath()), hasReadyItem: .constant(false))
}
