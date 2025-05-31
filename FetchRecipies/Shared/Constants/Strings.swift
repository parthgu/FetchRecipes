//
//  Strings.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

enum StringConstants {
    // MARK: - Navigation
    
    static let recipesTitle       = "Recipes"
    static let loadingPlaceholder = "Loading Recipes..."
    
    // MARK: - Empty & Error States
    
    static let emptyDefault       = "No recipes available."
    static let emptyFiltered      = "No recipes match “%@”."
    static let errorDefault       = "Something went wrong."
    static let errorSubtitle      = "There was a problem loading the data."
    static let emptyDeckTitle     = "Nothing to see here!"
    static let emptyDeckSubtitle  = "Check back later for more!"
    
    // MARK: - Buttons
    
    static let tryAgain           = "Try Again"
    static let refresh            = "Refresh"
    static let searchPlaceholder  = "Search recipes"
    static let source             = "Source"
    static let watch              = "Watch"
    
    // MARK: - Pills
    
    static let sortBy             = "Sort by"
    
    enum TabNames {
        static let favorites  = "Favorites"
        static let browse = "Browse"
        static let discover = "Discover"
    }
}
