//
//  ValidationViewModelTests.swift
//  ValidationViewModelTests
//
//  Created by DIMAS DAFFA ERNANDA on 10/05/26.
//

import XCTest
@testable import MyVaultApp

final class ValidationViewModelTests: XCTestCase {
    
    var viewModel: ValidationViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ValidationViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testEmotionGateFailsOnHighImpulse() throws{
        // Setup fake scenario (Simulate the user answering "Very Strongly" (5 points) to all 12 emotion questions)
        for i in 0..<viewModel.emotionQuestions.count {
            viewModel.emotionQuestions[i].score = 5
        }
        // Verify the app does what it's supposed to do
        // 60 points = 100% impulsive. The limit is 70%
        // isEmotionSafe MUST be false.
        XCTAssertFalse(viewModel.isEmotionSafe, "The emotion gate should fail when the impulse score is 100%.")
        
        // Because the emotion gate failed, the final decision MUST block the purchase
        XCTAssertFalse(viewModel.finalDecisionIsBuy, "The app should block the purchase when emotions are too high.")
    }
    
    func testFinanceGateFailsOnBadBudget() throws {
        // Set up a scenario where they pass the emotion test, but fail the finance test
        
        // Pass the emotion test by scoring a 1 on everything
        for i in 0..<viewModel.emotionQuestions.count {
            viewModel.emotionQuestions[i].score = 1
        }
        
        // Fail the finance test by answering "Yes" to "Does buying this take money away from savings?"
        // (Index 1 is the second finance question)
        viewModel.financeQuestions[1].answer = "Yes"
        
        XCTAssertFalse(viewModel.isFinanceSafe, "The finance gate should fail if savings are sacrificed.")
        XCTAssertFalse(viewModel.finalDecisionIsBuy, "The app should block the purchase if the budget fails, even if emotions are calm.")
    }
    
}
