//
//  SizeConstants.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import Foundation
import SwiftUI

/// Provides layout-related dimensions used throughout the swipeable card UI.
struct SizeConstants {
    /// Horizontal drag distance threshold (80% of half screen width) to trigger a swipe.
    static var screenCutoff: CGFloat {
        (UIScreen.main.bounds.width / 2) * 0.8
    }
    
    /// Width of each swipeable card, leaving 10pt margin on both sides.
    static var cardWidth: CGFloat {
        UIScreen.main.bounds.width - 20
    }
    
    /// Height of each swipeable card (about 69% of screen height).
    static var cardHeight: CGFloat {
        UIScreen.main.bounds.height / 1.45
    }
}
