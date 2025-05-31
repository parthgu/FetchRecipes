//
//  CardStackView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// A stack of swipeable recipe cards.
/// Only the top card handles drag gestures; swiping right favorites the recipe, left removes it.
struct CardStackView: View {
    let recipes: [Recipe]

    // ViewModel manages swipe state, xOffset, rotation, and deck ordering
    @StateObject private var viewModel = CardStackViewModel()

    // Pass favorites actions down to the ViewModel
    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        Group {
            if !viewModel.deck.isEmpty {
                VStack {
                    deckView
                    actionButtons
                }
            } else {
                EmptyDeckView()
            }
        }
        .onAppear {
            // Inject the FavoritesStore into the ViewModel and initialize the deck
            viewModel.favoritesStore = favoritesStore
            viewModel.loadDeck(from: recipes)
        }
        .onChange(of: recipes) { _, newRecipes in
            // Reload deck when the parent recipes array changes
            viewModel.loadDeck(from: newRecipes)
        }
    }

    // MARK: - Deck Rendering

    @ViewBuilder
    private var deckView: some View {
        ZStack {
            ForEach(viewModel.deck, id: \.id) { card in
                buildCard(for: card)
            }
        }
    }

    @ViewBuilder
    private func buildCard(for recipe: Recipe) -> some View {
        let isTop = (recipe == viewModel.topRecipe)

        SwipeableRecipeCardView(
            recipe: recipe,
            xOffset: isTop ? viewModel.xOffset : 0
        )
        .offset(x: isTop ? viewModel.xOffset : 0)
        .rotationEffect(.degrees(isTop ? viewModel.degrees : 0))
        .zIndex(isTop ? 1 : 0) // Keep the top card above others
        .gesture(
            isTop
                // Only attach drag gestures to the top card
                ? DragGesture()
                    .onChanged { value in
                        viewModel.onDragChanged(value)
                    }
                    .onEnded { value in
                        viewModel.onDragEnded(value)
                    }
                : nil
        )
        .animation(.snappy, value: viewModel.xOffset)
    }

    // MARK: - Action Buttons

    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 40) {
            // Force a left swipe (reject)
            Button {
                viewModel.swipeLeftAction()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.red)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)

            // Force a right swipe (favorite)
            Button {
                viewModel.swipeRightAction()
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.green)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
    }
}
