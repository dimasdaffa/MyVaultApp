//
//  HapticProvider.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 31/05/26.
//

import SwiftUI
import UIKit

protocol HapticProviding {
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType)
}

private struct HapticProviderKey: EnvironmentKey {
    static let defaultValue: any HapticProviding = HapticManager.shared
}

extension EnvironmentValues {
    var hapticProvider: any HapticProviding {
        get { self[HapticProviderKey.self] }
        set { self[HapticProviderKey.self] = newValue }
    }
}
