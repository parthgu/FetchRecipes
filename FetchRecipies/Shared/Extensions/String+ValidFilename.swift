//
//  String+ValidFilename.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

extension String {
    func toValidFilename() -> String {
        return self.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "_", options: .regularExpression)
    }
}
