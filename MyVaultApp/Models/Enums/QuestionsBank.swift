//
//  QuestionsData.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/06/26.
//

import Foundation

enum QuestionsData {
    static let emotionOptions: [EmotionScaleOption] = [
        EmotionScaleOption(label: "Very Strongly", score: 5),
        EmotionScaleOption(label: "Strongly", score: 4),
        EmotionScaleOption(label: "Moderately", score: 3),
        EmotionScaleOption(label: "Little", score: 2),
        EmotionScaleOption(label: "Least", score: 1)
    ]

    static let financeOptions: [FinanceAnswerOption] = [
        FinanceAnswerOption(value: "Yes"),
        FinanceAnswerOption(value: "No")
    ]
}

enum QuestionBank {
    static let emotionQuestions: [EmotionQuestion] = [
        // --- Standard Zone (1x Multiplier) ---
        EmotionQuestion(text: "Seeing influencers or friends enjoy this makes me want to own it immediately."),
        EmotionQuestion(text: "The product\u{2019}s appearance is so striking it overrides my original plans."),
        EmotionQuestion(text: "I want this specifically because it represents a new or unique trend."),
        EmotionQuestion(text: "The item fits an 'ideal version' of myself I want others to see."),

        // --- High Risk Zone (2x Multiplier) ---
        EmotionQuestion(text: "I feel I must act immediately because the stock is 'limited' or 'selling fast'."),
        EmotionQuestion(text: "I feel I 'deserve' this because of a special occasion, payday, or hard work."),
        EmotionQuestion(text: "The ease of checkout (QRIS/1-Tap) is the main reason I'm moving so fast."),

        // --- Critical Zone (3x Multiplier) ---
        EmotionQuestion(text: "I feel a physical restlessness or tension until I possess this item."),
        EmotionQuestion(text: "I am primarily buying this to escape a bad mood, stress, or to get an instant 'high'."),
        EmotionQuestion(text: "I am more afraid of 'losing the deal' than I am of losing the actual money.")
    ]

    static let financeQuestions: [FinanceQuestion] = [
        FinanceQuestion(text: "Will I have to work more than 3 business days just to pay for this?"),
        FinanceQuestion(text: "Does buying this take money away from my monthly savings goal?")
    ]
}
