//
//  CardView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// A full-screen, swipeable recipe card (Tinder-style) that displays the recipe image,
/// name, and cuisine. The `xOffset` value controls the swipe indicator overlay.
struct SwipeableRecipeCardView: View {
    let recipe: Recipe
    let xOffset: CGFloat  // Horizontal offset used to indicate swipe direction/strength

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                // Recipe image background; fills entire card area
                AsyncImageLoader(
                    url: recipe.photoURLLarge,
                    placeholder:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                )
                .scaledToFill()
                .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                
                // Overlay that shows swipe action (e.g., a like/dislike indicator based on xOffset)
                SwipeActionIndicatorView(xOffset: xOffset)
            }

            // Gradient-backed text overlay at bottom showing recipe name and cuisine
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .frame(width: SizeConstants.cardWidth, alignment: .leading)
            .background(
                // Gradient fades from transparent to semi-transparent black at bottom
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
            )
        }
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .cornerRadius(20)  // Rounded corners for a card-like appearance
    }
}
