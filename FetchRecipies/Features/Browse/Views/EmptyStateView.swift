//
//  EmptyStateView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Shows a placeholder when no content is available (e.g., no recipes found),
/// along with a button to retry or refresh the data.
struct EmptyStateView: View {
    let message: String
    let refreshAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Icon indicating an empty state
            Image(systemName: AssetNameConstants.emptyStateIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
            
            // Display the passed-in message in a subdued style
            Text(message)
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // Button that triggers the provided refresh action
            Button(action: refreshAction) {
                Text(StringConstants.refresh)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(.capsule)
            }
        }
    }
}
