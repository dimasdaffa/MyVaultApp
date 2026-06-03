//
//  ValidationViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import Combine

class ValidationViewModel: ObservableObject {
    @Published var activeItem: VaultItem?

    private let policy = ValidationPolicy.default

    // Categorized by risk for index-based multiplier logic
    @Published var emotionQuestions: [EmotionQuestion] = QuestionBank.emotionQuestions
    @Published var financeQuestions: [FinanceQuestion] = QuestionBank.financeQuestions
    
    @Published var currentEmotionIndex: Int = 0
    @Published var currentFinanceIndex: Int = 0
    
    // MARK: - Logic Layer
    var totalSteps: Int {
        emotionQuestions.count + financeQuestions.count
    }

    var currentTotalProgress: Int {
        currentEmotionIndex < emotionQuestions.count
        ? (currentEmotionIndex + 1)
        : (emotionQuestions.count + currentFinanceIndex + 1)
    }

    var currentFinanceProgress: Int {
        emotionQuestions.count + currentFinanceIndex + 1
    }
    
    // Weighted Calculation Logic
    var totalWeightedEmotionScore: Int {
        policy.totalWeightedEmotionScore(for: emotionQuestions)
    }
    
    //GATE 1: Emotion Threshold (Strict 50% - Safe if score <= 50)
    var isEmotionSafe: Bool {
        // Max possible weighted score is 100
        policy.isEmotionSafe(questions: emotionQuestions)
    }
    
    // GATE 2: Objective Financial Gate
    var isFinanceSafe: Bool {
        // Question index 1 is the savings goal question
        policy.isFinanceSafe(questions: financeQuestions)
    }
    
    // FINAL VERDICT: XOR Dual-Key Framework
    var finalDecisionIsBuy: Bool {
        policy.finalDecisionIsBuy(emotionQuestions: emotionQuestions, financeQuestions: financeQuestions)
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

