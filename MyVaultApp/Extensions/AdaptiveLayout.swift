//
//  AdaptiveLayout.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 20/04/26.
//
//  Provides responsive layout constraints for iPad compatibility.
//  Limits content width on larger screens (iPad 13") while keeping
//  iPhone layouts unchanged.
//

import SwiftUI

// MARK: - Adaptive Container Modifier

/// A ViewModifier that constrains content to a comfortable reading width on iPad,
/// centering it horizontally. On iPhone, content fills the full width as before.
struct AdaptiveContainerModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    /// The maximum width for content on regular-width devices (iPad).
    /// 600pt works well for form-like content on iPad 13-inch (1024pt wide).
    var maxWidth: CGFloat
    
    func body(content: Content) -> some View {
        if horizontalSizeClass == .regular {
            content
                .frame(maxWidth: maxWidth)
                .frame(maxWidth: .infinity) // Center within parent
        } else {
            content
        }
    }
}

extension View {
    /// Constrains this view's width on iPad while keeping full width on iPhone.
    /// - Parameter maxWidth: Maximum content width on iPad. Default is 600pt.
    func adaptiveContainer(maxWidth: CGFloat = 600) -> some View {
        modifier(AdaptiveContainerModifier(maxWidth: maxWidth))
    }
}
