//
//  LiveTimerView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 16/05/26.
//

import SwiftUI

struct LiveTimerView: View {
    let targetDate: Date
    let textColor: Color
    
    var body: some View {
        // TimelineView me-render Ulang SECARA LOKAL HANYA bagian jam ini setiap detiknya
        // Tanpa memaksa seluruh halaman Dashboard ikut di-render ulang
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            let remaining = max(0, targetDate.timeIntervalSince(context.date))
            
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Image(systemName: "timer").font(.system(size: 20)).opacity(0)
                Spacer()
                
                if remaining == 0 {
                    Text("00:").font(.system(size: 47)).foregroundStyle(textColor).monospacedDigit()
                    Text("00").font(.system(size: 47)).foregroundStyle(Color.themeRed.opacity(0.85)).monospacedDigit()
                    Text(":00").font(.system(size: 47)).foregroundStyle(textColor).monospacedDigit()
                    Spacer()
                    Image(systemName: "clock.badge.exclamationmark").font(.system(size: 20)).foregroundStyle(Color.themeRed.opacity(0.85))
                } else {
                    let h = String(format: "%02d", Int(remaining) / 3600)
                    let m = String(format: "%02d", (Int(remaining) % 3600) / 60)
                    let s = String(format: "%02d", Int(remaining) % 60)
                    
                    Text(h).font(.system(size: 52)).foregroundStyle(textColor).monospacedDigit()
                    Text(":\(m):\(s)").font(.system(size: 27)).foregroundStyle(textColor).monospacedDigit()
                    Spacer()
                    Image(systemName: "timer").font(.system(size: 20)).foregroundStyle(textColor)
                }
            }
            .padding(.horizontal, 15)
        }
    }
}
