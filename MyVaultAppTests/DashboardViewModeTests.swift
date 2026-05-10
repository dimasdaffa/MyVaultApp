//
//  DashboardViewModeTests.swift
//  MyVaultAppTests
//
//  Created by DIMAS DAFFA ERNANDA on 10/05/26.
//

import XCTest
@testable import MyVaultApp

@MainActor
final class DashboardViewModelTests: XCTestCase {

    var viewModel: DashboardViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = DashboardViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    // MARK: - Time Math Tests
    
    func testTimeFormatting() throws {
        // 1. ARRANGE: Set exactly 3665 seconds (1 hour, 1 minute, 5 seconds)
        let totalSeconds: TimeInterval = 3665
        
        // 2. ACT
        let formatted = viewModel.formatTime(totalSeconds)
        
        // 3. ASSERT
        XCTAssertEqual(formatted.h, "01", "Hours should be 01")
        XCTAssertEqual(formatted.m, "01", "Minutes should be 01")
        XCTAssertEqual(formatted.s, "05", "Seconds should be 05")
    }
    
    func testTimeRemainingCalculator() throws {
        // 1. ARRANGE: Create an item with a target date exactly 1 hour (3600 seconds) in the future
        let target = Date().addingTimeInterval(3600)
        let item = VaultItem(name: "Test Item", targetDate: target)
        
        // Force the ViewModel's current time to be exactly "now" so the math is predictable
        viewModel.currentTime = Date()
        
        // 2. ACT
        let remaining = viewModel.timeRemaining(for: item)
        
        // 3. ASSERT: Use `accuracy` because milliseconds might pass while the code executes!
        XCTAssertEqual(remaining, 3600, accuracy: 1.0, "Time remaining should be 3600 seconds, give or take 1 second.")
    }
    
    func testTimeDoesNotGoNegative() throws {
        // 1. ARRANGE: Create an item that finished 2 hours ago
        let pastTarget = Date().addingTimeInterval(-7200)
        let item = VaultItem(name: "Old Item", targetDate: pastTarget)
        viewModel.currentTime = Date()
        
        // 2. ACT
        let remaining = viewModel.timeRemaining(for: item)
        
        // 3. ASSERT
        XCTAssertEqual(remaining, 0, "Time remaining should stop at 0 and never go negative.")
    }

    // MARK: - Gravity Sorting Logic Tests
    
    func testProcessAndSortItemsGravity() throws {
        // 1. ARRANGE: Create 3 items in random order
        let item1 = VaultItem(name: "Finished Item", targetDate: Date().addingTimeInterval(-1000))
        item1.status = .coolingDown // Should be pushed to the bottom because it's at 0
        
        let item2 = VaultItem(name: "Longest Timer", targetDate: Date().addingTimeInterval(86400)) // 1 day left
        item2.status = .coolingDown // Should be at the very top
        
        let item3 = VaultItem(name: "Short Timer", targetDate: Date().addingTimeInterval(3600)) // 1 hour left
        item3.status = .coolingDown // Should be in the middle
        
        let unsortedItems = [item1, item2, item3]
        
        // 2. ACT
        let sortedUIList = viewModel.processAndSortItems(unsortedItems)
        
        // 3. ASSERT: Extract the items safely (since the list contains Optionals)
        let firstUIItem = sortedUIList[0]!
        let secondUIItem = sortedUIList[1]!
        let thirdUIItem = sortedUIList[2]!
        
        XCTAssertEqual(firstUIItem.name, "Longest Timer", "The item with the most time left should be at the top.")
        XCTAssertEqual(secondUIItem.name, "Short Timer", "The active item with less time should be in the middle.")
        XCTAssertEqual(thirdUIItem.name, "Finished Item", "The item with 0 seconds left should sink to the bottom.")
    }
}
