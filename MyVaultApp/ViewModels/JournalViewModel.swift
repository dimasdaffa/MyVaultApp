//
//  JournalViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/04/26.
//

import Combine
import Foundation
import SwiftData

struct EditingItem: Identifiable {
    let id = UUID()
    let index: Int
}

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
    
    // MARK: - Editing State
    @Published var editingItem: EditingItem? = nil
    @Published var draftAnswer: String = ""
    
    var totalQuestions: Int { questions.count }
    var currentProgress: Int { currentIndex + 1 }
    var isLastQuestion: Bool { currentIndex == totalQuestions - 1 }
    
    func nextQuestion() {
        if currentIndex < totalQuestions - 1 {
            currentIndex += 1
        }
    }
    
    // LOAD THE ITEM'S ANSWERS INTO THE VIEW MODEL
    func loadItem(_ item: VaultItem) {
        self.activeItem = item
        self.currentIndex = 0 // Reset to first question just in case
        
        // Decode the JSON string back into our question array
        if let data = item.emotionAnswer.data(using: .utf8),
           let loadedAnswers = try? JSONDecoder().decode([String].self, from: data) {
            for i in 0..<min(questions.count, loadedAnswers.count) {
                questions[i].answer = loadedAnswers[i]
            }
        } else {
            // Fallback if empty
            for i in 0..<questions.count {
                questions[i].answer = ""
            }
        }
    }
    
    // MARK: - Editing Actions
    
    /// Begin editing a specific question's answer
    func startEditing(at index: Int) {
        draftAnswer = questions[index].answer
        editingItem = EditingItem(index: index)
    }
    
    /// Save the draft answer back to the question and persist to the VaultItem
    func saveEdit() {
        guard let item = editingItem else { return }
        questions[item.index].answer = draftAnswer
        editingItem = nil
        
        // Auto-persist changes to the VaultItem so they survive dismissal
        lockInJournalAnswers()
    }
    
    /// Cancel editing without saving
    func cancelEdit() {
        editingItem = nil
    }
    
    // SAVE THE ANSWERS AS A JSON STRING
    func lockInJournalAnswers() {
        guard let item = activeItem else { return }
        
        let answers = questions.map { $0.answer }
        if let data = try? JSONEncoder().encode(answers),
           let jsonString = String(data: data, encoding: .utf8) {
            item.emotionAnswer = jsonString
        }
    }
    
    func resetJournal() {
        currentIndex = 0
        for i in 0..<questions.count {
            questions[i].answer = ""
        }
        activeItem = nil
    }
}
