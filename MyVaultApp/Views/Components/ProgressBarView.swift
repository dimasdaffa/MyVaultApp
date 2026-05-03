//
//  ProgressBarView.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//
//
//  ProgressBarView.swift
//  MyVaultApp
//

import SwiftUI

struct ProgressBarView: View {
    var currentStep: Int
    var totalSteps: Int
    
    var body: some View {
        GeometryReader { geometry in
            
            // Safely calculate the ratio
            let progressRatio = totalSteps > 0 ? (CGFloat(currentStep) / CGFloat(totalSteps)) : 0
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: geometry.size.width, height: 8)
                Capsule()
                    .fill(Color.themePrimary)
                    // Multiply the total width by our percentage
                    .frame(width: geometry.size.width * progressRatio, height: 8)
                    // Add a nice spring animation so it glides smoothly
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progressRatio)
            }
        }
        .frame(height: 8)
        .padding(.horizontal, 43)
    }
}

#Preview {
    VStack(spacing: 30) {
        ProgressBarView(currentStep: 1, totalSteps: 8) // Journal Start
        ProgressBarView(currentStep: 5, totalSteps: 8) // Journal Middle
        ProgressBarView(currentStep: 1, totalSteps: 2) // Emotion Question
        ProgressBarView(currentStep: 2, totalSteps: 2) // Finance Question
    }
}
