//
//  Shimmer.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// A view modifier that applies a moving shimmer effect over the content.
struct ShimmerViewModifier: ViewModifier {
    let speed: Double           // Duration for the shimmer to traverse
    let color: Color            // Base color of the shimmer highlight
    let angle: Double           // Rotation angle of the shimmer gradient
    let animateOpacity: Bool    // Whether to animate opacity pulse
    let animateScale: Bool      // Whether to animate scale pulse
    @State private var move = false

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    // Create a narrow gradient bar that moves across the view
                    let gradient = LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0),
                            color.opacity(0.5),
                            color.opacity(0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    Rectangle()
                        .fill(gradient)
                        .rotationEffect(.degrees(angle))
                        // Size: half the width, twice the height to cover diagonally when rotated
                        .frame(
                            width: geometry.size.width / 2.5,
                            height: geometry.size.height * 2
                        )
                        // Position off-screen to the left initially; animate to just past the right edge
                        .offset(
                            x: move ? geometry.size.width * 1.1 : -geometry.size.width * 1.4,
                            y: -geometry.size.height / 2
                        )
                        .animation(
                            .linear(duration: speed).repeatForever(autoreverses: false),
                            value: move
                        )
                        .onAppear {
                            // Delay slightly to ensure view has rendered before starting
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                move = true
                            }
                        }
                }
            }
            // Mask the shimmer overlay to the shape of the original content
            .mask(content)
            // Optionally pulse scale or opacity in sync with the shimmer movement
            .scaleEffect(animateScale ? (move ? 1 : 0.95) : 1)
            .opacity(animateOpacity ? (move ? 1 : 0.5) : 1)
            .animation(
                (animateOpacity || animateScale)
                    ? .linear(duration: 1).repeatForever(autoreverses: true)
                    : nil,
                value: move
            )
    }
}

extension View {
    /// Applies a shimmer effect over any view.
    /// - Parameters:
    ///   - speed: How long it takes the shimmer to move across (default 1.5s).
    ///   - color: The highlight color (default white).
    ///   - angle: Rotation angle of the shimmer bar (default 0°).
    ///   - animateOpacity: Whether to pulse opacity alongside the movement.
    ///   - animateScale: Whether to pulse scale alongside the movement.
    func shimmer(
        speed: Double = 1.5,
        color: Color = .white,
        angle: Double = 0,
        animateOpacity: Bool = false,
        animateScale: Bool = false
    ) -> some View {
        modifier(
            ShimmerViewModifier(
                speed: speed,
                color: color,
                angle: angle,
                animateOpacity: animateOpacity,
                animateScale: animateScale
            )
        )
    }
}
