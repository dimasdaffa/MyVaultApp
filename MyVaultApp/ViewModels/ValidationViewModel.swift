//
//  ValidationViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import Combine

class ValidationViewModel: ObservableObject {
    @Published var activeItem: VaultItem?
    
    @Published var emotionQuestions: [EmotionQuestion] = [
        EmotionQuestion(text: "I feel this price is a \"special deal\" that won't last."),
        EmotionQuestion(text: "The current discount/offer is the primary reason I want it now."),
        EmotionQuestion(text: "The product's appearance is so striking it overrides my budget."),
        EmotionQuestion(text: "I feel I must act now because the stock is \"limited.\""),
        EmotionQuestion(text: "Seeing others enjoy this product makes me want to own it immediately."),
        EmotionQuestion(text: "I believe buying this will provide an instant \"mood boost\"."),
        EmotionQuestion(text: "I am more afraid of losing this deal than spending the money."),
        EmotionQuestion(text: "I want this specifically because it is a new or unique trend."),
        EmotionQuestion(text: "The ease of checkout (e.g., QRIS/1-Tap) makes me want to proceed."),
        EmotionQuestion(text: "A live demo or influencer review has convinced me I need this."),
        EmotionQuestion(text: "I have a physical urge to possess this item right this second."),
        EmotionQuestion(text: "I feel justified buying this because it's a special occasion/payday.")
    ]
    
    @Published var financeQuestions: [FinanceQuestion] = [
        FinanceQuestion(text: "Will I have to work more than 3 business days just to pay for this?"),
        FinanceQuestion(text: "Does buying this take money away from my monthly savings goal?")
    ]
    
    @Published var currentEmotionIndex: Int = 0
    @Published var currentFinanceIndex: Int = 0
    
    var currentTotalProgress: Int {
        currentEmotionIndex < 12 ? (currentEmotionIndex + 1) : (12 + currentFinanceIndex + 1)
    }
    
    // LOGIC
    // Hitung total poin dari 12 EMOTION QUESTION
    var totalEmotionScore: Int {
        emotionQuestions.compactMap { $0.score }.reduce(0, +)
    }
    
    // Hitung persentase impulsif
    var emotionPercentage: Double {
        (Double(totalEmotionScore) / 60.0) * 100.0
    }
    
    // GATE 1: Apakah lolos EMOTION QUESTION? (Harus < 70%, alias poin <= 41)
    var isEmotionSafe: Bool {
        emotionPercentage < 70.0
    }
    
    // GATE 2: Apakah lolos FINANCIAL QUESTION? (Q2 harus "No")
    var isFinanceSafe: Bool {
        financeQuestions[1].answer == "No"
    }
    
    // RESULT
    var finalDecisionIsBuy: Bool {
        return isEmotionSafe && isFinanceSafe
    }
    
    func nextEmotionQuestion() {
        if currentEmotionIndex < emotionQuestions.count - 1 {
            currentEmotionIndex += 1
        }
    }
    
    func nextFinanceQuestion() {
        if currentFinanceIndex < financeQuestions.count - 1 {
            currentFinanceIndex += 1
        }
    }
    
    func startValidation(for item: VaultItem) {
        self.activeItem = item
        self.currentEmotionIndex = 0
        self.currentFinanceIndex = 0
        
        // Reset all previous scores so it's a fresh quiz
        for i in 0..<emotionQuestions.count {
            emotionQuestions[i].score = nil
        }
        for i in 0..<financeQuestions.count {
            financeQuestions[i].answer = nil
        }
    }
    
    func finalizeValidation() -> Bool {
        // Ensure we actually have an item loaded
        guard let item = activeItem else { return false }
        
        // Calculate the final decision based on your existing logic
        let isBuy = finalDecisionIsBuy
        
        // Update the item's status in SwiftData
        if isBuy {
            item.status = .bought
        } else {
            item.status = .saved
        }
        
        // Return the decision to the View for routing
        return isBuy
    }
}

