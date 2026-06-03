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


