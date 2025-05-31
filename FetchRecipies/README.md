# FetchRecipies 🍳

A modern SwiftUI recipe discovery app that helps you explore, save, and find your next favorite meal. Built with Swift's latest features and following best practices in iOS development.

## Features

### 🔍 Browse

- Browse through a curated list of recipes from various cuisines
- Search recipes by name or cuisine type
- Sort recipes alphabetically (A-Z or Z-A)
- View detailed recipe information including:
  - High-quality photos
  - Cuisine type
  - Source links
  - YouTube tutorials (when available)
- Share recipes with friends

### ❤️ Favorites

- Save your favorite recipes for quick access
- Manage your collection of saved recipes
- Access your favorites offline
- Remove recipes from favorites with a single tap

### 🎲 Discover

- Tinder-style recipe discovery interface
- Swipe right to add to favorites
- Swipe left to skip
- Beautiful full-screen recipe cards
- Quick decision making for meal planning

## Technical Highlights

### Modern Swift Features

- Built entirely with SwiftUI
- Leverages `async/await` for all asynchronous operations
- Uses Swift Concurrency for efficient background tasks
- MVVM architecture for clean separation of concerns

### Networking & Data Management

- Custom implementation of efficient network layer
- Smart image caching system to minimize bandwidth usage
- Robust error handling for various API scenarios:
  - Malformed data handling
  - Empty state management
  - Network error recovery

### Performance

- Lazy loading of images and content
- Efficient memory management
- Smooth animations and transitions
- Responsive UI across all iPhone sizes

### Zero Dependencies

- Built entirely with Apple frameworks
- No external dependencies required
- Self-contained image caching solution
- Custom networking implementation

## API Endpoints

The app uses the following endpoints:

- Main: `https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json`
- Test Endpoints:
  - Malformed Data: `https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json`
  - Empty Data: `https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json`

## Requirements

- iOS 18.0+
- Xcode 14.0+
- Swift 5.5+

## Installation

1. Clone the repository
2. Open `FetchRecipies.xcodeproj` in Xcode
3. Build and run the project

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern and is organized into the following main directories:

- `Features/`: Contains feature-specific code organized by domain
  - `Browse/`: Browse tab implementation
  - `Favorites/`: Favorites management
  - `Discover/`: Recipe discovery interface
- `Core/`: Core application components
- `Networking/`: API and networking layer
- `Shared/`: Shared utilities and components
- `Resources/`: Assets and resource files

## Testing

The app includes unit tests focusing on core business logic:

- Data fetching
- Caching mechanisms
- Data transformation
- Business logic validation

## Error Handling

The app gracefully handles various error scenarios:

- Network connectivity issues
- Malformed API responses
- Empty data states
- Image loading failures

## Credits

Created by Parth Gupta as part of the Fetch iOS coding challenge.
