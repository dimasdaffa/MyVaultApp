//
//  TimeoutView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI
import Combine

struct TimeoutView: View {
    @Binding var navPath: NavigationPath
    @EnvironmentObject var journalVM: JournalViewModel
    
    // THE TIMER STATES
    @State private var isTimerFinished: Bool
    @State private var timeRemaining: TimeInterval
    @State private var showJournalSheet = false
    
    // THE HEARTBEAT PUBLISHER (Fires every 1 second)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // This allows DashboardView to pass 'isTimerFinished' smoothly
    init(navPath: Binding<NavigationPath>, isTimerFinished: Bool) {
        self._navPath = navPath
        self._isTimerFinished = State(initialValue: isTimerFinished)
        
        // MOCK DATA: If finished, set 0. If not, set a 15-second countdown for testing!
        // (In the real app, this will calculate the difference from the target date)
        self._timeRemaining = State(initialValue: isTimerFinished ? 0 : 15)
    }
    
    // TIME FORMATTING HELPERS
    var hours: String { String(format: "%02d", Int(timeRemaining) / 3600) }
    var minutes: String { String(format: "%02d", (Int(timeRemaining) % 3600) / 60) }
    var seconds: String { String(format: "%02d", Int(timeRemaining) % 60) }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    HStack {
                        Text(isTimerFinished ? "Time" : "Cooling")
                            .font(.system(size: 45))
                            .bold()
                        Text(isTimerFinished ? "Out." : "Down.")
                            .font(.system(size: 45))
                            .bold()
                            .foregroundColor(Color.themePrimary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 31)
            
            HStack {
                VStack(alignment: .leading) {
                    if isTimerFinished {
                        Text("Review your mood and your bank")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("account one last time before")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("making the call.")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                    } else {
                        Text("Take a deep breath and let your")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("emotions settle down before")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                        Text("making a decision.")
                            .font(.system(size: 19))
                            .fontWeight(.light)
                    }
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
                TextField("", text: .constant("New Balance 740"))
                    .foregroundColor(.primary)
                    .disabled(true)
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
                HStack {
                    HStack {
                        Image(systemName: "dollarsign")
                            .font(.system(size: 20))
                        TextField("", text: .constant("1.740.000"))
                            .disabled(true)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: 400)
                    .padding(19)
                    .background(Color.themeCard)
                    .cornerRadius(42)
                    
                    HStack {
                        Text("IDR")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                            .disabled(true)
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
                HStack {
                    Image(systemName: "link")
                        .font(.system(size: 20))
                    TextField("", text: .constant("http://foot.com/nb740"))
                        .disabled(true)
                        .foregroundColor(.primary)
                }
                .padding(19)
                .background(Color.themeCard)
                .cornerRadius(42)
            }
            .padding(.top, 14)
            .padding(.horizontal, 31)
            
            HStack {
                Spacer()
                Button {
                    showJournalSheet = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text(isTimerFinished ? "Read Initial Thoughts" : "Review & Edit Thoughts")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.themePrimary)
                    .underline()
                }
            }
            .padding(.top, 5)
            .padding(.horizontal, 30)
            
            Spacer()
            
            // THE LIVE TICKING DISPLAY
            VStack {
                Text("REMAINING DURATION")
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                HStack(spacing: 0) {
                    Text("\(hours):")
                        .foregroundStyle(Color.themeBackground)
                    Text("\(minutes)")
                        .foregroundStyle(isTimerFinished ? Color.themePrimary : Color.themeBackground)
                    Text(":\(seconds)")
                        .foregroundStyle(Color.themeBackground)
                }
                .font(.system(size: 58))
                .monospacedDigit() // Membuat size angka sama
            }
            .padding(30)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 42)
                    .fill(Color.themeBlack)
            )
            .padding(.horizontal, 30)
            
            Button {
                navPath.append("EmotionQuestion")
            } label: {
                Text("Validate Answer")
                    .fontWeight(.medium)
                    .foregroundColor(isTimerFinished ? .white : .gray)
                    .frame(width: 350, height: 62)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(isTimerFinished ? Color.themePrimary : Color.gray.opacity(0.3))
                    )
                    .shadow(color: isTimerFinished ? Color.themePrimary.opacity(0.8) : Color.clear, radius: 10, x: 0, y: 5)
            }
            .background(Color.themeBackground)
            .disabled(!isTimerFinished)
            
        }
        .navigationTitle(isTimerFinished ? "Validation" : "Cooling Down")
        .sheet(isPresented: $showJournalSheet) {
            NavigationStack {
                ReviewJournalView(navPath: $navPath, isPresentedAsSheet: true, canEdit: !isTimerFinished)
            }
            .environmentObject(journalVM)
        }
        // THE ENGINE LOGIC
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                // Tick down by 1 second
                timeRemaining -= 1
            } else {
                // Lock it in when it hits zero
                withAnimation(.spring()) {
                    isTimerFinished = true
                }
                // Cancel the timer to save system memory
                timer.upstream.connect().cancel()
            }
        }
    }
}

#Preview {
    TimeoutView(navPath: .constant(NavigationPath()), isTimerFinished: false)
        .environmentObject(JournalViewModel())
}
