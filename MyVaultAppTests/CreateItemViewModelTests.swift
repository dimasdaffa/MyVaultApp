//
//  CreateItemViewModelTests.swift
//  MyVaultAppTests
//
//  Created by DIMAS DAFFA ERNANDA on 10/05/26.
//

import XCTest
@testable import MyVaultApp

@MainActor
final class CreateItemViewModelTests: XCTestCase {
    
    var viewModel: CreateItemViewModel!
    var mockJournal: JournalViewModel!
    
    // Dummy JournalViewModel because prepareItem() requires it
    var mockJournalVM: JournalViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CreateItemViewModel()
        mockJournalVM = JournalViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockJournalVM = nil
        try super.tearDownWithError()
    }
    
//     MARK: - Form Validation Tests
    
    func testFormIsInvalidWhenEmpty() throws {
        XCTAssertFalse(viewModel.isFormValid, "Form should be invalid when title and price are empty.")
    }
    
    func testFormIsInvalidWhenPriceIsZero() throws {
        // 1. ARRANGE
        viewModel.itemTitle = "Apple Vision Pro"
        viewModel.itemPrice = "0"
        
        // 2. ASSERT
        XCTAssertFalse(viewModel.isFormValid, "Form should be invalid if the price is exactly 0.")
    }
    
    func testFormIsValidWithCorrectData() throws {
        // 1. ARRANGE
        viewModel.itemTitle = "New Balance 990v6"
        viewModel.itemPrice = "4500000"
        
        // 2. ASSERT
        XCTAssertTrue(viewModel.isFormValid, "Form should be valid when both a title and a valid price are provided.")
    }
    
    // MARK: - Currency Formatting Tests
    
    func testIDRCurrencyFormatting() throws {
        // 1. ARRANGE
        viewModel.selectedCurrency = .idr
        
        // 2. ACT: Simulate the user typing "1500000" into the text field
        viewModel.onPriceChanged("1500000")
        
        // 3. ASSERT: IDR should use dots as grouping separators
        XCTAssertEqual(viewModel.itemPrice, "1.500.000", "IDR currency should format with dot separators.")
    }
    
    func testUSDCurrencyFormatting() throws {
        // 1. ARRANGE
        viewModel.selectedCurrency = .usd
        
        // 2. ACT: Simulate the user typing "1500" into the text field
        viewModel.onPriceChanged("1500")
        
        // 3. ASSERT: USD should use commas as grouping separators
        XCTAssertEqual(viewModel.itemPrice, "1,500", "USD currency should format with comma separators.")
    }
    
}
