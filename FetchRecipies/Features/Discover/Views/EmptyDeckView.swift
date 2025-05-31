//
//  EmptyDeckView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

struct EmptyDeckView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: AssetNameConstants.emptyDeckIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
            
            Text(StringConstants.emptyDeckTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(StringConstants.emptyDeckSubtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
