//
//  HistoryViewModelTests.swift
//  MyVaultAppTests
//
//  Created by DIMAS DAFFA ERNANDA on 10/05/26.
//

import XCTest
import SwiftData
@testable import MyVaultApp

final class HistoryViewModelTests: XCTestCase {

    private var viewModel: HistoryViewModel!
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = HistoryViewModel()
        // Use an in-memory SwiftData store so tests never touch disk.
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: VaultItem.self, configurations: config)
        context = ModelContext(container)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        container = nil
        context = nil
        try super.tearDownWithError()
    }

    func testGetHistoryFiltersOutActiveItems() throws {
        // Arrange: two active items and two finished items.
        let cooling = VaultItem(name: "Cooling", targetDate: Date())
        cooling.status = .coolingDown

        let ready = VaultItem(name: "Ready", targetDate: Date())
        ready.status = .ready

        let bought = VaultItem(name: "Bought", targetDate: Date())
        bought.status = .bought

        let saved = VaultItem(name: "Saved", targetDate: Date())
        saved.status = .saved

        let allItems = [cooling, ready, bought, saved]

        // Act: get history-only items.
        let history = viewModel.getHistory(from: allItems)

        // Assert: only finished items are returned.
        XCTAssertEqual(history.count, 2)
        XCTAssertTrue(history.contains { $0.name == "Bought" })
        XCTAssertTrue(history.contains { $0.name == "Saved" })
        XCTAssertFalse(history.contains { $0.name == "Cooling" })
        XCTAssertFalse(history.contains { $0.name == "Ready" })
    }

    func testDeleteItemsRemovesFromContext() throws {
        // Arrange: insert three items into SwiftData.
        let item1 = VaultItem(name: "Item 1", targetDate: Date())
        item1.status = .bought

        let item2 = VaultItem(name: "Item 2", targetDate: Date())
        item2.status = .saved

        let item3 = VaultItem(name: "Item 3", targetDate: Date())
        item3.status = .bought

        [item1, item2, item3].forEach { context.insert($0) }
        try context.save()

        let historyItems = [item1, item2, item3]

        // Act: delete the second item.
        viewModel.deleteItems(at: IndexSet(integer: 1), from: historyItems, context: context)
        try context.save()

        // Assert: only two remain, and the deleted one is gone.
        let remaining = try context.fetch(FetchDescriptor<VaultItem>())
        XCTAssertEqual(remaining.count, 2)
        XCTAssertFalse(remaining.contains { $0.name == "Item 2" })
    }

}
