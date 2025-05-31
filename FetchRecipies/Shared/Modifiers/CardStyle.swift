//
//  CardStyle.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// A view modifier that applies a card-like appearance:
/// horizontal padding, a light background, rounded corners, and a subtle shadow.
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

extension View {
    /// Applies the `CardStyle` modifier for a consistent card appearance.
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
