# Copilot Instructions for QualityFruitApp

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
This is a Flutter mobile application called **QualityFruitApp** designed for fruit quality assessment.

## Development Guidelines

### Architecture
- Follow Flutter best practices and Material Design guidelines
- Use Provider or Riverpod for state management
- Implement clean architecture with separation of concerns
- Use proper folder structure: lib/features, lib/core, lib/shared

### Code Style
- Use Dart and Flutter naming conventions
- Add comprehensive documentation for public APIs
- Implement proper error handling
- Use const constructors where possible for performance

### Key Features to Consider
- Fruit quality assessment functionality
- Image capture and analysis
- Data persistence (local storage)
- User-friendly interface
- Offline capabilities

### Dependencies to Prefer
- `provider` or `riverpod` for state management
- `image_picker` for camera functionality
- `sqflite` for local database
- `shared_preferences` for app settings
- `http` for API calls if needed

## Testing
- Write unit tests for business logic
- Implement widget tests for UI components
- Consider integration tests for complete user flows
