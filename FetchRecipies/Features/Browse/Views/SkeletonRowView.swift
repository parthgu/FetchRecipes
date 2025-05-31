//
//  SkeletonRowView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct SkeletonRowView: View {
    var body: some View {
        HStack {
            // image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .shimmer(color: .gray.opacity(0.7))

            VStack(alignment: .leading, spacing: 8) {
                // title placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .cornerRadius(4)
                    .shimmer(color: .gray.opacity(0.7))

                // subtitle placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
                    .cornerRadius(4)
                    .shimmer(color: .gray.opacity(0.7))
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
