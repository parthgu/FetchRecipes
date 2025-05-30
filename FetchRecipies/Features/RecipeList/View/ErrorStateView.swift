//
//  ErrorStateView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

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
            Image("alert", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            VStack (spacing: 12) {
                Text(message)
                    .fontWeight(.bold)
                if let subtitle = subtitle {
                    Text(subtitle)
                }
            }
            .multilineTextAlignment(.center)
            Button(action: retryAction) {
                Text("Try Again")
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
#Preview {
    ErrorStateView(message: "Something went wrong", subtitle: "There was a problem loading the data.", retryAction: { })
}
