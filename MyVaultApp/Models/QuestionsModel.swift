//
//  ValidationModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import Foundation

struct JournalQuestion {
    let text: String
    var answer: String = ""
}

struct EmotionQuestion {
    let text: String
    var score: Int?
}

struct FinanceQuestion {
    let text: String
    var answer: String?
}

struct EmotionScaleOption: Identifiable, Hashable {
    let label: String
    let score: Int

    var id: String { label }
}

struct FinanceAnswerOption: Identifiable, Hashable {
    let value: String

    var id: String { value }
}

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

