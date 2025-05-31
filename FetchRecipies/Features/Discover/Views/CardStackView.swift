//
//  CardStackView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// A stack of swipeable cards where only the top card responds to drags.
/// Swiping right adds the recipe to favorites; swiping left removes it.
struct CardStackView: View {
    let recipes: [Recipe]

    /// The view model encapsulates all the swipe logic and deck state.
    @StateObject private var viewModel = CardStackViewModel()

    /// FavoritesStore is used by the view model; we assign it in onAppear.
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
            // Provide the favorites store to the view model, then load the initial deck.
            viewModel.favoritesStore = favoritesStore
            viewModel.loadDeck(from: recipes)
        }
        .onChange(of: recipes) { _, newRecipes in
            // Reload deck whenever `recipes` changes from the parent.
            viewModel.loadDeck(from: newRecipes)
        }
    }

    // MARK: - Card Stack

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
        // Determine if this is the top card
        let isTop = recipe == viewModel.topRecipe

        SwipeableRecipeCardView(recipe: recipe, xOffset: isTop ? viewModel.xOffset : 0)
            .offset(x: isTop ? viewModel.xOffset : 0)
            .rotationEffect(.degrees(isTop ? viewModel.degrees : 0))
            .zIndex(isTop ? 1 : 0)
            .gesture(
                isTop
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
            // “X” button for swipe left
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

            // “Heart” button for swipe right
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
