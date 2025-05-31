//
//  String+ValidFilename.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

extension String {
    /// Replaces any character not alphanumeric with an underscore to create a filesystem-safe filename.
    func toValidFilename() -> String {
        // Regex "[^a-zA-Z0-9]" matches any character that's not a letter or digit.
        return self.replacingOccurrences(
            of: "[^a-zA-Z0-9]",
            with: "_",
            options: .regularExpression
        )
    }
}
