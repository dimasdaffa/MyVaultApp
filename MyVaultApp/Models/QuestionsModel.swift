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

