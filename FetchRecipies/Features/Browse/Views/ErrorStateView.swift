//
//  ErrorStateView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Displays an error image, message, optional subtitle, and a retry button.
/// Used when loading recipes fails or other errors occur.
struct ErrorStateView: View {
    let message: String
    let subtitle: String?
    let retryAction: () -> Void
    
    init(message: String, subtitle: String? = nil, retryAction: @escaping () -> Void) {
        self.message = message
        self.subtitle = subtitle
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: 20) {
            // Error illustration
            Image(AssetNameConstants.alert, bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack(spacing: 12) {
                Text(message)
                    .fontWeight(.bold)
                // Show subtitle only if provided
                if let subtitle = subtitle {
                    Text(subtitle)
                }
            }
            .multilineTextAlignment(.center)
            
            // Retry button triggers the provided closure
            Button(action: retryAction) {
                Text(StringConstants.tryAgain)
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
