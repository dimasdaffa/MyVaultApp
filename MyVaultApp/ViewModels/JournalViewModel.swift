//
//  JournalViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import Combine
import Foundation
import SwiftData

class JournalViewModel: ObservableObject{
    @Published var questions: [JournalQuestion] = [
        JournalQuestion(text: "Is this item going to add value to my life?"),
        JournalQuestion(text: "Is it something I will use regularly?"),
        JournalQuestion(text: "Will it bring me joy?"),
        JournalQuestion(text: "Do I have a specific use and a place to store it?"),
        JournalQuestion(text: "Is having this more important than my goal?"),
        JournalQuestion(text: "Am I willing to maintain this item?"),
        JournalQuestion(text: "If it was full price, would I still buy it?"),
        JournalQuestion(text: "Is this thing worth my time?")
    ]
    
    @Published var currentIndex: Int = 0
    @Published var activeItem: VaultItem?
    
    var totalQuestions: Int { questions.count }
    var currentProgress: Int { currentIndex + 1 }
    var isLastQuestion: Bool { currentIndex == totalQuestions - 1 }
    
    func nextQuestion() {
        if currentIndex < totalQuestions - 1 {
            currentIndex += 1
        }
    }
    
    // THIS JUST SAVES THE DATA (Call this when they finish the questions)
    func lockInJournalAnswers() {
        guard let item = activeItem else { return }
        
        var combinedJournalEntry = ""
        
        for (index, question) in questions.enumerated() {
            if !question.answer.trimmingCharacters(in: .whitespaces).isEmpty {
                combinedJournalEntry += "Q\(index + 1): \(question.text)\n"
                combinedJournalEntry += "A: \(question.answer)\n\n"
            }
        }
        
        item.emotionAnswer = combinedJournalEntry.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // THIS CLEARS THE DATA (Call this ONLY when leaving the Review screen to go home)
    func resetJournal() {
        currentIndex = 0
        for i in 0..<questions.count {
            questions[i].answer = ""
        }
        activeItem = nil
    }
}
