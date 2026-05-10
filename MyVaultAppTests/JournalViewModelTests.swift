//
//  JournalViewModelTests.swift
//  MyVaultAppTests
//
//  Created by DIMAS DAFFA ERNANDA on 10/05/26.
//

import XCTest
@testable import MyVaultApp

final class JournalViewModelTests: XCTestCase {

    private var viewModel: JournalViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = JournalViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testNextQuestionStopsAtLastIndex() throws {
        // Arrange: set index to the last question.
        viewModel.currentIndex = viewModel.totalQuestions - 1

        // Act: try to move forward.
        viewModel.nextQuestion()

        // Assert: index does not go past the end.
        XCTAssertEqual(viewModel.currentIndex, viewModel.totalQuestions - 1)
    }

    func testLoadItemResetsIndexAndLoadsAnswers() throws {
        // Arrange: store answers on a VaultItem as JSON.
        let answers = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8"]
        let data = try JSONEncoder().encode(answers)
        let json = String(data: data, encoding: .utf8) ?? ""

        let item = VaultItem(name: "Item", targetDate: Date())
        item.emotionAnswer = json

        viewModel.currentIndex = 3

        // Act: load the item.
        viewModel.loadItem(item)

        // Assert: index resets and answers are loaded.
        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertEqual(viewModel.questions[0].answer, "A1")
        XCTAssertEqual(viewModel.questions[7].answer, "A8")
    }

    func testStartEditingAndCancelKeepsOriginalAnswer() throws {
        // Arrange: start editing a question.
        viewModel.questions[0].answer = "Original"
        viewModel.startEditing(at: 0)
        viewModel.draftAnswer = "Edited"

        // Act: cancel the edit.
        viewModel.cancelEdit()

        // Assert: draft is discarded and original stays.
        XCTAssertNil(viewModel.editingItem)
        XCTAssertEqual(viewModel.questions[0].answer, "Original")
    }

    func testSaveEditPersistsToItem() throws {
        // Arrange: load an item so edits can be persisted.
        let item = VaultItem(name: "Item", targetDate: Date())
        viewModel.loadItem(item)

        viewModel.questions[1].answer = "Old"
        viewModel.startEditing(at: 1)
        viewModel.draftAnswer = "New"

        // Act: save the edit.
        viewModel.saveEdit()

        // Assert: question is updated and JSON on the item is updated.
        XCTAssertNil(viewModel.editingItem)
        XCTAssertEqual(viewModel.questions[1].answer, "New")

        let data = item.emotionAnswer.data(using: .utf8)
        let decoded = try JSONDecoder().decode([String].self, from: data ?? Data())
        XCTAssertEqual(decoded[1], "New")
    }

    func testResetJournalClearsState() throws {
        // Arrange: set some state.
        let item = VaultItem(name: "Item", targetDate: Date())
        viewModel.loadItem(item)
        viewModel.currentIndex = 2
        viewModel.questions[0].answer = "Something"

        // Act: reset.
        viewModel.resetJournal()

        // Assert: everything is cleared.
        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertNil(viewModel.activeItem)
        XCTAssertTrue(viewModel.questions.allSatisfy { $0.answer.isEmpty })
    }

}
