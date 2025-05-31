//
//  CardStackViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

@MainActor
final class CardStackViewModel: ObservableObject {
    // Current stack of recipes that can be swiped (excludes favorites and is shuffled)
    @Published var deck: [Recipe] = []

    // Horizontal drag offset for the top card
    @Published var xOffset: CGFloat = 0

    // Rotation angle in degrees for the top card during drag
    @Published var degrees: Double = 0

    // Injected by the view so we can add/remove favorites
    weak var favoritesStore: FavoritesStore?

    // MARK: - Public API

    /// Filters out any recipes already favorited and shuffles the rest to form the deck.
    func loadDeck(from recipes: [Recipe]) {
        guard let store = favoritesStore else { return }
        deck = recipes
            .filter { !store.contains($0.id) }
            .shuffled()
    }

    /// The recipe at the top of the stack (last element in `deck`).
    var topRecipe: Recipe? {
        deck.last
    }

    /// Called continuously during a drag gesture; updates offset and rotation.
    func onDragChanged(_ value: DragGesture.Value) {
        xOffset = value.translation.width
        // Rotate proportionally: wider swipe → greater tilt
        degrees = Double(value.translation.width / 25)
    }

    /// Called when dragging ends; determines if the top card should snap back or be swiped away.
    func onDragEnded(_ value: DragGesture.Value) {
        let width = value.translation.width
        let cutoff = SizeConstants.screenCutoff

        guard let recipe = topRecipe else { return }

        switch width {
        case let w where abs(w) <= cutoff:
            // Not far enough: reset to center
            returnToCenter()
        case let w where w > cutoff:
            // Swiped right: favorite
            performSwipeRight(on: recipe)
        default:
            // Swiped left: remove (and unfavorite)
            performSwipeLeft(on: recipe)
        }
    }

    /// Programmatically trigger a right swipe (e.g., via a button tap).
    func swipeRightAction() {
        guard let recipe = topRecipe else { return }
        performSwipeRight(on: recipe)
    }

    /// Programmatically trigger a left swipe (e.g., via a button tap).
    func swipeLeftAction() {
        guard let recipe = topRecipe else { return }
        performSwipeLeft(on: recipe)
    }

    // MARK: - Private Helpers

    private func performSwipeRight(on recipe: Recipe) {
        // Animate card off-screen to the right with a slight rotation
        xOffset = 500
        degrees = 12

        favoritesStore?.add(recipe.id)
        removeTopCard()
    }

    private func performSwipeLeft(on recipe: Recipe) {
        xOffset = -500
        degrees = -12

        favoritesStore?.remove(recipe.id)
        removeTopCard()
    }

    private func returnToCenter() {
        xOffset = 0
        degrees = 0
    }

    /// Removes the top card after a brief delay to allow the swipe animation to complete.
    private func removeTopCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard !self.deck.isEmpty else { return }
            _ = self.deck.removeLast()
            self.returnToCenter()
        }
    }
}
