# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sellout is a Flutter marketplace application with business services and personal user features. The app supports both personal marketplace functionality (listings, cart, orders, chat) and business services (bookings, scheduling, payments).

## Common Development Commands

```bash
# Build and run
flutter run
flutter build apk
flutter build ios

# Code generation (for Hive models and json serialization)
flutter packages pub run build_runner build
flutter packages pub run build_runner build --delete-conflicting-outputs

# Linting and analysis
flutter analyze
flutter test

# Clean and get dependencies
flutter clean
flutter pub get

# Generate app icons and splash screens
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

## Architecture

The project follows **Clean Architecture** with **Domain-Driven Design** principles:

### Core Structure
- `lib/core/` - Shared utilities, widgets, extensions, and infrastructure
- `lib/features/` - Feature modules organized by domain
- `lib/routes/` - Navigation and routing configuration
- `lib/services/` - Dependency injection and app-wide services

### Feature Organization
Each feature follows clean architecture layers:
```
features/
├── domain/
│   ├── entities/       # Domain models
│   ├── repositories/   # Repository interfaces
│   ├── usecase/       # Business logic use cases
│   └── params/        # Use case parameters
├── data/
│   ├── models/        # Data models with serialization
│   ├── repositories/  # Repository implementations
│   └── sources/       # Data sources (API, local)
└── views/
    ├── screens/       # UI screens
    ├── widgets/       # Reusable UI components
    └── providers/     # State management (Provider pattern)
```

### Main Feature Domains
- **Personal Features**: `lib/features/personal/`
  - Auth (signin, signup, find_account)
  - Marketplace (listings, search, filters)
  - Cart and Orders
  - Chat system with real-time messaging
  - User profiles and visits
  - Post management with feeds
  - Notifications and reviews
  
- **Business Features**: `lib/features/business/`
  - Business pages and profiles
  - Service management
  - Booking system with calendar integration
  
- **Shared**: `lib/features/attachment/` - File and media handling

## State Management

Uses **Provider** pattern for state management. Key providers:
- Feature-specific providers in each feature's `views/providers/` directory
- Global providers configured in `services/app_providers.dart`

## Data Persistence

- **Hive** for local storage (user data, cache)
- **SharedPreferences** for simple key-value storage
- Models use Hive annotations for local storage serialization

## Key Dependencies

- **Provider** - State management
- **Hive** - Local database
- **GetIt** - Dependency injection
- **HTTP** - API calls
- **Socket.IO** - Real-time messaging
- **Flutter Stripe** - Payments
- **Google Maps** - Location services
- **Easy Localization** - Internationalization
- **Syncfusion Calendar** - Booking calendar

## Environment Configuration

The app uses environment files:
- `dev.env` - Development configuration
- `prod.env` - Production configuration

Environment is automatically selected based on debug mode in `main.dart:20`.

## Code Generation

Several files use code generation:
- Hive models (`.g.dart` files)
- JSON serialization
- Run `flutter packages pub run build_runner build` after modifying entities/models

## Testing and Quality

- Linting rules configured in `analysis_options.yaml`
- Uses `flutter_lints` package
- Custom rules enforce:
  - Always specify types
  - Single quotes preference
  - Relative imports within lib/
  - Required parameters first

## Development Notes

- The app supports both light and dark themes
- Real-time features implemented via Socket.IO
- Payment processing via Stripe
- Comprehensive permission handling for camera, contacts, location
- Multi-language support with Easy Localization
- Extensive use of custom widgets in `lib/core/widgets/`