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
    
    var body: some View {
        VStack(spacing: -150) {
            
            Button {
                navPath.append("Timeout_Waiting")
            } label: {
                VStack {
                    Text("New Balance 740")
                        .font(.system(size: 36))
                        .bold()
                        .foregroundStyle(.primary)
                    HStack(alignment: .lastTextBaseline, spacing: 0){
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                            .opacity(0)
                        Spacer()
                        Text("48")
                            .font(.system(size: 52))
                        Text(":00:00")
                            .font(.system(size: 27))
                        Spacer()
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.top, 40)
                .padding(.bottom, 10)
                .background(
                    UnevenRoundedRectangle(bottomLeadingRadius: 123)
                        .fill(Color.themeBackground)
                )
            }
            .buttonStyle(SolidPressButtonStyle())
            .zIndex(3)
            
            Button {
                navPath.append("Timeout_Waiting")
            } label: {
                VStack {
                    Text("Salomon XT")
                        .font(.system(size: 36))
                        .bold()
                        .foregroundStyle(.white)
                    HStack(alignment: .lastTextBaseline, spacing: 0){
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                            .opacity(0)
                        Spacer()
                        Text("23")
                            .font(.system(size: 52))
                            .foregroundStyle(.white)
                        Text(":12:00")
                            .font(.system(size: 27))
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.top, 170)
                .padding(.bottom, 10)
                .background(
                    UnevenRoundedRectangle(bottomLeadingRadius: 123)
                        .fill(Color.themePrimary)
                )
            }
            .buttonStyle(SolidPressButtonStyle())
            .zIndex(2)
            
            Button {
                navPath.append("Timeout_Ready")
            } label: {
                VStack {
                    Text("Nintendo DS Lite")
                        .font(.system(size: 36))
                        .bold()
                        .foregroundStyle(.white)
                    HStack(alignment: .lastTextBaseline, spacing: 0){
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                            .opacity(0)
                        Spacer()
                        Text("00:")
                            .font(.system(size: 47))
                            .foregroundStyle(.white)
                        Text("00")
                            .font(.system(size: 47))
                            .foregroundStyle(Color.themeRed.opacity(0.75))
                        Text(":00")
                            .font(.system(size: 47))
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.themeRed.opacity(0.75))
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.top, 170)
                .padding(.bottom, 10)
                .background(
                    UnevenRoundedRectangle(bottomLeadingRadius: 123)
                        .fill(Color.themeBlack)
                )
            }
            .buttonStyle(SolidPressButtonStyle())
            .zIndex(1)
        }
    }
}

#Preview {
    CardView(navPath: .constant(NavigationPath()))
}
