//
//  ValidationViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import Combine

class ValidationViewModel: ObservableObject {
    @Published var activeItem: VaultItem?
    
    // Categorized by risk for index-based multiplier logic
    @Published var emotionQuestions: [EmotionQuestion] = [
        // --- Standard Zone (1x Multiplier) ---
        EmotionQuestion(text: "Seeing influencers or friends enjoy this makes me want to own it immediately."), // Social Proof
        EmotionQuestion(text: "The product’s appearance is so striking it overrides my original plans."), // Aesthetics
        EmotionQuestion(text: "I want this specifically because it represents a new or unique trend."), // Novelty
        EmotionQuestion(text: "The item fits an 'ideal version' of myself I want others to see."), // Identity
        
        // --- High Risk Zone (2x Multiplier) ---
        EmotionQuestion(text: "I feel I must act immediately because the stock is 'limited' or 'selling fast'."), // Scarcity
        EmotionQuestion(text: "I feel I 'deserve' this because of a special occasion, payday, or hard work."), // Justification
        EmotionQuestion(text: "The ease of checkout (QRIS/1-Tap) is the main reason I'm moving so fast."), // Frictionless
        
        // --- Critical Zone (3x Multiplier) ---
        EmotionQuestion(text: "I feel a physical restlessness or tension until I possess this item."), // Physical Urge
        EmotionQuestion(text: "I am primarily buying this to escape a bad mood, stress, or to get an instant 'high'."), // Mood Repair
        EmotionQuestion(text: "I am more afraid of 'losing the deal' than I am of losing the actual money.") // Loss Aversion
    ]
    
    @Published var financeQuestions: [FinanceQuestion] = [
        FinanceQuestion(text: "Will I have to work more than 3 business days just to pay for this?"),
        FinanceQuestion(text: "Does buying this take money away from my monthly savings goal?")
    ]
    
    @Published var currentEmotionIndex: Int = 0
    @Published var currentFinanceIndex: Int = 0
    
    // MARK: - Logic Layer
    var currentTotalProgress: Int {
        currentEmotionIndex < 10 ? (currentEmotionIndex + 1) : (10 + currentFinanceIndex + 1)
    }
    
    // Weighted Calculation Logic
    var totalWeightedEmotionScore: Int {
        var total = 0
        for (index, question) in emotionQuestions.enumerated() {
            let rawScore = question.score ?? 0
            
            switch index {
            case 7...9: // Critical Zone (3x)
                total += (rawScore * 3)
            case 4...6: // High Risk Zone (2x)
                total += (rawScore * 2)
            default:    // Standard Zone (1x)
                total += rawScore
            }
        }
        return total
    }
    
    //GATE 1: Emotion Threshold (Strict 50% - Safe if score <= 50)
    var isEmotionSafe: Bool {
        // Max possible weighted score is 100
        totalWeightedEmotionScore <= 50
    }
    
    // GATE 2: Objective Financial Gate
    var isFinanceSafe: Bool {
        // Question index 1 is the savings goal question
        financeQuestions[1].answer == "No"
    }
    
    // FINAL VERDICT: XOR Dual-Key Framework
    var finalDecisionIsBuy: Bool {
        return isEmotionSafe && isFinanceSafe
    }
    
    // MARK: - Functions
    
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
        
        for i in 0..<emotionQuestions.count {
            emotionQuestions[i].score = nil
        }
        for i in 0..<financeQuestions.count {
            financeQuestions[i].answer = nil
        }
    }
    
    func finalizeValidation() -> Bool {
        guard let item = activeItem else { return false }
        
        let isBuy = finalDecisionIsBuy
        
        if isBuy {
            item.status = .bought
        } else {
            item.status = .saved
        }
        
        return isBuy
    }
}

