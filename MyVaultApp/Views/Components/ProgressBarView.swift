//
//  ProgressBarView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct ProgressBarView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 6)
                .frame(width:350, height: 12)
                .foregroundColor(Color.themeCard)
            RoundedRectangle(cornerRadius: 6)
                .frame(width:100, height: 12)
                .foregroundColor(Color.themePrimary)
                .offset(x:-124)
        }
        .frame(minHeight: 0, maxHeight: 20)
        .frame(width: 20)
    }
}

#Preview {
    ProgressBarView()
}
