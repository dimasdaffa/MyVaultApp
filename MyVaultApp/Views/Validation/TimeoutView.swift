//
//  TimeoutView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct TimeoutView: View {
    enum Currency {
        case rm
        case idr
        case usd
    }
    
    @Binding var navPath: NavigationPath
    @State private var text = ""
    @State private var showJournalSheet = false
    @EnvironmentObject var journalVM: JournalViewModel
    
    @State private var isTimerFinished: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    HStack {
                        Text("Time")
                            .font(.system(size: 45))
                            .bold()
                        Text("Out.")
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
                    Text("Review your mood and your bank")
                        .font(.system(size: 19))
                        .fontWeight(.light)
                    Text("account one last time before")
                        .font(.system(size: 19))
                        .fontWeight(.light)
                    Text("making the call.")
                        .font(.system(size: 19))
                        .fontWeight(.light)
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
            
            VStack {
                Text("REMAINING DURATION")
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                HStack(spacing: 0) {
                    Text("00:")
                        .font(.system(size: 58))
                        .foregroundStyle(Color.themeBackground)
                    Text("00")
                        .font(.system(size: 58))
                        .foregroundStyle(Color.themeRed.opacity(0.75))
                    Text(":00")
                        .font(.system(size: 58))
                        .foregroundStyle(Color.themeBackground)
                }
            }
            .padding(30)
            .padding(.horizontal, 25)
            .background(
                RoundedRectangle(cornerRadius: 42)
                    .fill(Color.themeBlack)
            )
            
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
    }
}

#Preview {
    TimeoutView(navPath: .constant(NavigationPath()))
        .environmentObject(JournalViewModel())
}
