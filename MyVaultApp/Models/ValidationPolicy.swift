//
//  ValidationPolicy.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 31/05/26.
//

import Foundation

struct ValidationPolicy {
    let emotionWeights: [Int]
    let emotionSafeThreshold: Int
    let financeSafeIndex: Int
    let financeSafeAnswer: String

    static let `default` = ValidationPolicy(
        emotionWeights: [1, 1, 1, 1, 2, 2, 2, 3, 3, 3],
        emotionSafeThreshold: 50,
        financeSafeIndex: 1,
        financeSafeAnswer: "No"
    )

    func totalWeightedEmotionScore(for questions: [EmotionQuestion]) -> Int {
        var total = 0
        for (index, question) in questions.enumerated() {
            let rawScore = question.score ?? 0
            let weight = index < emotionWeights.count ? emotionWeights[index] : 1
            total += rawScore * weight
        }
        return total
    }

    func isEmotionSafe(questions: [EmotionQuestion]) -> Bool {
        totalWeightedEmotionScore(for: questions) <= emotionSafeThreshold
    }

    func isFinanceSafe(questions: [FinanceQuestion]) -> Bool {
        questions[financeSafeIndex].answer == financeSafeAnswer
    }

    func finalDecisionIsBuy(emotionQuestions: [EmotionQuestion], financeQuestions: [FinanceQuestion]) -> Bool {
        isEmotionSafe(questions: emotionQuestions) && isFinanceSafe(questions: financeQuestions)
    }
}
