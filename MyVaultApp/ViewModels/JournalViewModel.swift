//
//  JournalViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//
import Combine
import Foundation

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
    
    var totalQuestions: Int { questions.count }
    var currentProgress: Int { currentIndex + 1 }
    var isLastQuestion: Bool { currentIndex == totalQuestions - 1 }
    
    func nextQuestion() {
        if currentIndex < totalQuestions - 1 {
            currentIndex += 1
        }
    }
}
