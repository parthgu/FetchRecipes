//
//  SwipeActionIndicatorView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// Shows “LIKE” and “NOPE” indicators with dynamic opacity based on the horizontal swipe offset.
/// As the user swipes right (positive xOffset), the “LIKE” text fades in;
/// as the user swipes left (negative xOffset), the “NOPE” text fades in.
struct SwipeActionIndicatorView: View {
    let xOffset: CGFloat  // Current horizontal drag offset from the card's center

    var body: some View {
        HStack {
            Text("LIKE")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.green)
                .overlay {
                    // Green border around the text
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.green, lineWidth: 2)
                        .frame(width: 100, height: 48)
                }
                .rotationEffect(.degrees(-45))
                // Opacity scales proportionally to xOffset; only visible when swiping right
                .opacity(Double(xOffset / SizeConstants.screenCutoff))

            Spacer()

            Text("NOPE")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.red)
                .overlay {
                    // Red border around the text
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.red, lineWidth: 2)
                        .frame(width: 100, height: 48)
                }
                .rotationEffect(.degrees(45))
                // Inverse opacity: visible when swiping left (negative xOffset)
                .opacity(Double(xOffset / SizeConstants.screenCutoff) * -1)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 30)
    }
}
