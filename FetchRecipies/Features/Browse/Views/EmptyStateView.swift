//
//  EmptyStateView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    let refreshAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: AssetNameConstants.emptyStateIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
            Text(message)
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

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
