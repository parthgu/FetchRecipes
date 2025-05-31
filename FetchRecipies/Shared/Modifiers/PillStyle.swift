//
//  PillStyle.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// A reusable view modifier that styles content as a “pill” with padding, background, and rounded corners.
struct PillStyle: ViewModifier {
    var horizontal: CGFloat = 12
    var vertical: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .font(.subheadline).bold()
            .padding(.vertical, vertical)
            .padding(.horizontal, horizontal)
            .background(Color.accentColor.opacity(0.2))
            .foregroundColor(.accentColor)
            .cornerRadius(12)
    }
}

extension View {
    /// Applies the `PillStyle` modifier with optional custom padding.
    func pillStyle(h: CGFloat = 12, v: CGFloat = 8) -> some View {
        modifier(PillStyle(horizontal: h, vertical: v))
    }
}
