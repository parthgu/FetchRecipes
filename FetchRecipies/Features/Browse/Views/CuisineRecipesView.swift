//
//  CuisineRecipesView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct CuisineRecipesView: View {
    let cuisine: String
    let recipes: [Recipe]    // the already-filtered list

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        VStack(spacing: 0) {
                            AsyncImageLoader(
                                url: recipe.photoURLSmall,
                                placeholder:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .aspectRatio(1, contentMode: .fit)
                                        .cornerRadius(8)
                            )

                            Text(recipe.name)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 4)
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(cuisine)
    }
}

