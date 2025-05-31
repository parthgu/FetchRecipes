//
//  CardStackViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

@MainActor
final class CardStackViewModel: ObservableObject {
    // MARK: - Published state

    /// The current stack of recipes to display (filtered + shuffled).
    @Published var deck: [Recipe] = []

    /// Horizontal offset used for dragging the top card.
    @Published var xOffset: CGFloat = 0

    /// Rotation angle (in degrees) while dragging.
    @Published var degrees: Double = 0

    /// A reference to the favorites store; assigned by the view in onAppear.
    weak var favoritesStore: FavoritesStore?

    // MARK: - Public API

    /// Sets up `deck` by filtering out recipes already in favorites and shuffling.
    func loadDeck(from recipes: [Recipe]) {
        guard let store = favoritesStore else { return }
        deck = recipes
            .filter { !store.contains($0.id) }
            .shuffled()
    }

    /// The topmost recipe in the deck (the one currently draggable).
    var topRecipe: Recipe? {
        deck.last
    }

    /// Call this whenever the user’s drag changes. Updates offset and rotation.
    func onDragChanged(_ value: DragGesture.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }

    /// Call this when the drag ends. Decides whether to swipe left/right or return to center.
    func onDragEnded(_ value: DragGesture.Value) {
        let width = value.translation.width
        let cutoff = SizeConstants.screenCutoff

        guard let recipe = topRecipe else {
            return
        }

        switch width {
        case let w where abs(w) <= cutoff:
            returnToCenter()
        case let w where w > cutoff:
            performSwipeRight(on: recipe)
        default:
            performSwipeLeft(on: recipe)
        }
    }

    /// Trigger a programmatic “swipe right” (e.g. via button):
    func swipeRightAction() {
        guard let recipe = topRecipe else { return }
        performSwipeRight(on: recipe)
    }

    /// Trigger a programmatic “swipe left” (e.g. via button):
    func swipeLeftAction() {
        guard let recipe = topRecipe else { return }
        performSwipeLeft(on: recipe)
    }

    // MARK: - Private helpers

    private func performSwipeRight(on recipe: Recipe) {
        // Move card off-screen to the right and rotate
        xOffset = 500
        degrees = 12

        // Update favorites
        favoritesStore?.add(recipe.id)

        // Remove the card after a slight delay to allow animation
        removeTopCard()
    }

    private func performSwipeLeft(on recipe: Recipe) {
        xOffset = -500
        degrees = -12

        // Remove from favorites (in case it was there)
        favoritesStore?.remove(recipe.id)

        removeTopCard()
    }

    private func returnToCenter() {
        xOffset = 0
        degrees = 0
    }

    private func removeTopCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard !self.deck.isEmpty else { return }
            _ = self.deck.removeLast()
            self.returnToCenter()
        }
    }
}

