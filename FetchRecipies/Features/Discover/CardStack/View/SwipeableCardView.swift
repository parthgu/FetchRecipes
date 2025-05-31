//
//  CardView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// A single full-screen recipe card UI (Tinder-style) with fixed dimensions relative to the screen.
struct SwipeableRecipeCardView: View {
    let recipe: Recipe
    let xOffset: CGFloat

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                // Background image
                AsyncImageLoader(
                    url: recipe.photoURLLarge,
                    placeholder:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                )
                .scaledToFill()
                .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                
                SwipeActionIndicatorView(xOffset: xOffset)
            }

            // Text overlay with static gradient background
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
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
            )
        }
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .cornerRadius(20)
    }
}
