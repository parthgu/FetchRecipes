//
//  EmptyDeckView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// Shown when there are no more cards to swipe in the deck.
/// Displays an icon and explanatory text indicating the deck is empty.
struct EmptyDeckView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Icon representing empty deck state
            Image(systemName: AssetNameConstants.emptyDeckIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
            
            // Title text for empty deck
            Text(StringConstants.emptyDeckTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Subtitle text providing additional context
            Text(StringConstants.emptyDeckSubtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
