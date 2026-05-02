//
//  DashboardViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 02/05/26.
//
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    // 1. THE DATA
    @Published var items: [VaultItem] = [
        VaultItem(name: "New Balance 740", timeRemaining: 172763, isEmpty: false),
        VaultItem(name: "Salomon XT", timeRemaining: 15, isEmpty: false), // Watch this drop!
        VaultItem(name: "", timeRemaining: 0, isEmpty: true)
    ]
    
    // 2. THE ALERT STATE
    @Published var hasReadyItem: Bool = false
    
    private var timerCancellable: AnyCancellable?
    
    init() {
        checkReadyItems()
        startTimer()
    }
    
    // 3. BULLETPROOF GRAVITY SORTING
    var sortedItems: [VaultItem] {
        items.sorted { item1, item2 in
            func getScore(for item: VaultItem) -> Int {
                if item.isEmpty { return 0 }
                if item.timeRemaining > 0 { return 1 }
                return 2
            }
            return getScore(for: item1) < getScore(for: item2)
        }
    }
    
    // 4. TIME FORMATTER
    func formatTime(_ totalSeconds: TimeInterval) -> (h: String, m: String, s: String) {
        let h = String(format: "%02d", Int(totalSeconds) / 3600)
        let m = String(format: "%02d", (Int(totalSeconds) % 3600) / 60)
        let s = String(format: "%02d", Int(totalSeconds) % 60)
        return (h, m, s)
    }
    
    // 5. THE ENGINE
    private func checkReadyItems() {
        hasReadyItem = items.contains(where: { !$0.isEmpty && $0.timeRemaining == 0 })
    }
    
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        var foundReady = false
        
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
                
                if items[i].timeRemaining == 0 {
                    foundReady = true
                }
            }
        }
        
        if hasReadyItem != foundReady {
            withAnimation(.easeInOut(duration: 0.3)) {
                hasReadyItem = foundReady
            }
        }
    }
}



