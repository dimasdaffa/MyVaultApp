//
//  CardView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: -150) {
                VStack {
                    Text("New Balance 740")
                        .font(.system(size: 36))
                        .bold()
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
                .zIndex(3)
                
                VStack {
                    Text("Salomon XT")
                        .font(.system(size: 36))
                        .bold()
                    HStack(alignment: .lastTextBaseline, spacing: 0){
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                            .opacity(0)
                        Spacer()
                        Text("23")
                            .font(.system(size: 52))
                        Text(":12:00")
                            .font(.system(size: 27))
                        Spacer()
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal, 15)
                }
                .foregroundStyle(Color.themeBackground)
                .padding(.top, 170)
                .padding(.bottom, 10)
                .background(
                    UnevenRoundedRectangle(bottomLeadingRadius: 123)
                        .fill(Color.themePrimary)
                    )
                .zIndex(2)
                
                NavigationLink{
                    TimeoutView()
                } label: {
                    VStack {
                        Text("Nintendo DS Lite")
                            .font(.system(size: 36))
                            .bold()
                        HStack(alignment: .lastTextBaseline, spacing: 0){
                            Image(systemName: "timer")
                                .font(.system(size: 20))
                                .opacity(0)
                            Spacer()
                            Text("00:")
                                .font(.system(size: 47))
                            Text("00")
                                .font(.system(size: 47))
                                .foregroundStyle(Color.themeRed.opacity(0.75))
                            Text(":00")
                                .font(.system(size: 47))
                            Spacer()
                            Image(systemName: "clock.badge.exclamationmark")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.themeRed.opacity(0.75))
                        }
                        .padding(.horizontal, 15)
                    }
                    .foregroundStyle(Color.themeBackground)
                    .padding(.top, 170)
                    .padding(.bottom, 10)
                    .background(
                        UnevenRoundedRectangle(bottomLeadingRadius: 123)
                            .fill(Color.themeBlack)
                    )
                }
                .zIndex(1)
            }
        }
    }
}

#Preview {
    CardView()
}
