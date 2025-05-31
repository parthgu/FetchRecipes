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

    @State private var deck: [Recipe] = []
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0

    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        Group {
            if !deck.isEmpty {
                VStack {
                    deckView
                    actionButtons
                }
            } else {
                EmptyDeckView()
            }
        }
        .onAppear {
            deck = recipes
                .filter { !favoritesStore.contains($0.id) }
                .shuffled()
        }
        .onChange(of: recipes) { _, new in
            deck = new
                .filter { !favoritesStore.contains($0.id) }
                .shuffled()
        }
    }
    
    // MARK: - Break out the card construction

    @ViewBuilder
    private func buildCard(for recipe: Recipe) -> some View {
        let isTop = recipe == deck.last

        SwipeableRecipeCardView(recipe: recipe, xOffset: isTop ? xOffset : 0)
            .offset(x: isTop ? xOffset : 0)
            .rotationEffect(.degrees(isTop ? degrees : 0))
            .zIndex(isTop ? 1 : 0)
            .gesture(isTop ? topGesture(recipe: recipe) : nil)
            .animation(.snappy, value: xOffset)
    }
    
    // MARK: - Gesture property

    private func topGesture(recipe: Recipe) -> some Gesture {
        DragGesture()
            .onChanged { v in onDragChanged(v) }
            .onEnded { v in onDragEnded(v, recipe: recipe) }
    }
    
    @ViewBuilder
    private var deckView: some View {
        ZStack {
            ForEach(deck, id: \.id) { card in
                buildCard(for: card)
            }
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 40) {
            // “X” button for swipe left
            Button {
                if let last = deck.last {
                    swipeLeft(last)
                }
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
                if let last = deck.last {
                    swipeRight(last)
                }
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

private extension CardStackView {
    // keep onDragEnded simple — just pick the right handler
    func onDragChanged(_ value: DragGesture.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }

    func onDragEnded(_ value: DragGesture.Value, recipe: Recipe) {
        let width = value.translation.width
        let cutoff = SizeConstants.screenCutoff

        if abs(width) <= cutoff {
            returnToCenter()
        } else if width > cutoff {
            swipeRight(recipe)
        } else {
            swipeLeft(recipe)
        }
    }

    func swipeRight(_ recipe: Recipe) {
        xOffset = 500; degrees = 12
        favoritesStore.add(recipe.id)
        removeTopCard()
    }

    func swipeLeft(_ recipe: Recipe) {
        xOffset = -500; degrees = -12
        favoritesStore.remove(recipe.id)
        removeTopCard()
    }

    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }

    func removeTopCard() {
        // give the swipe animation time to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !deck.isEmpty {
                deck.removeLast()
                returnToCenter()
            }
        }
        
    }
}
