//
//  TimeoutViewModelTests.swift
//  MyVaultAppTests
//
//  Created by DIMAS DAFFA ERNANDA on 10/05/26.
//

import XCTest
@testable import MyVaultApp

@MainActor
final class TimeoutViewModelTests: XCTestCase {

    private var viewModel: TimeoutViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testTimerSetsRemainingWhenFutureDate() throws {
        // Arrange: an item in the future.
        let target = Date().addingTimeInterval(90)
        let item = VaultItem(name: "Future", targetDate: target)

        // Act: initialize and update the timer.
        viewModel = TimeoutViewModel(item: item)
        viewModel.updateTimer()

        // Assert: timer is running with time remaining.
        XCTAssertFalse(viewModel.isTimerFinished)
        XCTAssertGreaterThan(viewModel.timeRemaining, 0)
    }

    func testTimerFinishesWhenPastDate() throws {
        // Arrange: an item already in the past.
        let target = Date().addingTimeInterval(-10)
        let item = VaultItem(name: "Past", targetDate: target)

        // Act: initialize and update the timer.
        viewModel = TimeoutViewModel(item: item)
        viewModel.updateTimer()

        // Assert: timer is finished and time is zero.
        XCTAssertTrue(viewModel.isTimerFinished)
        XCTAssertEqual(viewModel.timeRemaining, 0)
    }

    func testTimeFormattingPadsZeros() throws {
        // Arrange: known timeRemaining value.
        let target = Date().addingTimeInterval(3665)
        let item = VaultItem(name: "Format", targetDate: target)

        viewModel = TimeoutViewModel(item: item)
        viewModel.timeRemaining = 3665

        // Assert: all units are zero-padded to 2 digits.
        XCTAssertEqual(viewModel.hours, "01")
        XCTAssertEqual(viewModel.minutes, "01")
        XCTAssertEqual(viewModel.seconds, "05")
    }

}
