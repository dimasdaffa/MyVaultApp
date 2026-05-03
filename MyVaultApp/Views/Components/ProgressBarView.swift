//
//  ProgressBarView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct ProgressBarView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    
    var body: some View {
        // GeometryReader lets us perfectly measure the screen width
        GeometryReader { geometry in
            
            // Calculate the percentage (e.g., Question 1 of 8 = 0.125)
            let progressRatio = CGFloat(viewModel.currentIndex + 1) / CGFloat(viewModel.totalQuestions)
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: geometry.size.width, height: 8)
                
                Capsule()
                    .fill(Color.themePrimary)
                    // Multiply the total width by our percentage
                    .frame(width: geometry.size.width * progressRatio, height: 8)
                    // Add a nice spring animation so it glides when they hit "Next"
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progressRatio)
            }
        }
        .frame(height: 8)
        .padding(.horizontal, 43)
    }
}

#Preview {
    ProgressBarView()
        .environmentObject(JournalViewModel())
}
