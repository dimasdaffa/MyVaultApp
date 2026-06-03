//
//  VaultItemRepository.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 31/05/26.
//

import SwiftData
import SwiftUI

protocol VaultItemRepository {
    func insert(_ item: VaultItem)
    func delete(_ item: VaultItem)
    func save() throws
}

struct SwiftDataVaultItemRepository: VaultItemRepository {
    let context: ModelContext

    func insert(_ item: VaultItem) {
        context.insert(item)
    }

    func delete(_ item: VaultItem) {
        context.delete(item)
    }

    func save() throws {
        try context.save()
    }
}

typealias VaultItemRepositoryFactory = (ModelContext) -> any VaultItemRepository

private struct VaultItemRepositoryFactoryKey: EnvironmentKey {
    static let defaultValue: VaultItemRepositoryFactory = { context in
        SwiftDataVaultItemRepository(context: context)
    }
}

extension EnvironmentValues {
    var vaultItemRepositoryFactory: VaultItemRepositoryFactory {
        get { self[VaultItemRepositoryFactoryKey.self] }
        set { self[VaultItemRepositoryFactoryKey.self] = newValue }
    }
}
