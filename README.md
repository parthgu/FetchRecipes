# FetchRecipies 🍳

A modern SwiftUI recipe discovery app that helps you explore, save, and find your next favorite meal.

### Summary

[Screenshots/Video to be added showing:]
- Browse tab with recipe list, search, and sorting functionality
- Recipe detail view with high-quality photos and sharing options
- Favorites tab displaying saved recipes
- Tinder-style recipe discovery interface
- Error states and empty states handling

### Focus Areas

1. **User Experience & Interface**
   - Clean, intuitive navigation between three main sections (Browse, Favorites, Discover)
   - Smooth animations and transitions, especially in the Tinder-style discovery view
   - Responsive search and filtering capabilities
   - Meaningful error and empty states

2. **Performance & Efficiency**
   - Custom image caching system to minimize network usage
   - Efficient memory management with disk and memory caching
   - Responsive UI
   - Smart data loading and state management

3. **Modern Swift Implementation**
   - Full SwiftUI implementation for UI components
   - Leveraging async/await for all asynchronous operations
   - MVVM architecture for clean code organization
   - Zero external dependencies as required

### Time Spent

Approximately 12 hours total, allocated as follows:

- Initial setup and architecture planning: ~2 hours
- Core functionality (Browse, API integration): ~3 hours
- Image caching system: ~2 hours
- Favorites implementation: ~1.5 hours
- Discover (Tinder-style) feature: ~2 hours
- Polish, error handling, and testing: ~1.5 hours

### Trade-offs and Decisions

1. **Dependency Injection**
   - Chose to use singletons and direct dependencies for time efficiency
   - Trade-off: Less testable and harder to modify dependencies
   - Alternative would have been a proper DI system for better testing and modularity

2. **Scalability Considerations**
   - Focused on getting core features working reliably
   - Some architectural decisions might need revision for larger scale:
     - Current caching system might need optimization for larger datasets
     - State management could be more robust
     - Network layer could be more configurable

3. **Testing Approach**
   - Prioritized testing core business logic and data flow
   - Limited UI testing due to time constraints
   - Focused on critical paths rather than comprehensive coverage

### Weakest Part of the Project

The dependency management approach is the weakest aspect of the project. Using singletons and direct dependencies makes the code:
- More tightly coupled
- Harder to test thoroughly
- More challenging to modify or extend
- Less flexible for future requirements

A better approach would have been:
- Implementing a proper dependency injection system
- Using protocols for better abstraction
- Creating more modular components
- Setting up a comprehensive testing infrastructure

### Additional Information

1. **Project Structure**
   - Organized by feature modules for better maintainability
   - Shared utilities and components for reusability
   - Clear separation of concerns in MVVM pattern

2. **Future Improvements**
   - Implement proper dependency injection
   - Add more comprehensive test coverage
   - Enhance caching system with size limits and expiration
   - Add offline support for browsing favorites
   - Implement more advanced sorting and filtering options

3. **Technical Notes**
   - Built with iOS 18.0+ to leverage latest SwiftUI features
   - Custom image caching implementation as per requirements
   - Error handling covers all edge cases in API responses
   - No external dependencies used as specified
