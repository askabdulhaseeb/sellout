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

Uses **Provider** pattern with **GetIt** for dependency injection:
- Feature-specific providers in each feature's `views/providers/` directory
- Global providers configured in `services/app_providers.dart`
- All services and repositories registered in `services/get_it.dart` via `setupLocator()`

## Data Persistence

- **Hive** for local storage with encryption (50+ type adapters in `lib/core/sources/local/hive_db.dart`)
- **SharedPreferences** for simple key-value storage
- Models use Hive annotations (`@HiveType`, `@HiveField`) for local storage serialization
- Encrypted storage managed by `EncryptionKeyManager`

## API Communication

All API calls go through `lib/core/sources/api_call.dart`:
- Returns `DataSuccess<T>` or `DataFailer<T>` wrapper classes
- Automatic Bearer token injection from `LocalAuth`
- JSON validation and sanitization before sending
- Supports both JSON body and multipart form data uploads

## Real-Time Communication (Socket.IO)

Uses **Handler Registry Pattern** - see `SOCKET_SERVICE.md` for full documentation:
- `lib/core/sockets/socket_service.dart` - Thin connection manager
- `lib/core/sockets/handlers/` - Base handler and registry
- Feature handlers located in their feature folders under `data/sources/socket/`

Key handlers:
- `PresenceHandler` (core) - Online/offline status, last seen
- `ChatSocketHandler` - Messages, upload progress
- `WalletSocketHandler` - Wallet balance, payout status
- `NotificationSocketHandler` - Push notifications

## Environment Configuration

The app uses environment files:
- `dev.env` - Development configuration
- `prod.env` - Production configuration


Environment is automatically selected based on debug mode in `main.dart:36`.

## Code Generation

Several files use code generation:
- Hive models (`.g.dart` files)
- JSON serialization
- Run `flutter packages pub run build_runner build` after modifying entities/models

## Linting Rules

Configured in `analysis_options.yaml`:
- `always_specify_types: true` - Always declare types explicitly
- `prefer_single_quotes: true` - Use single quotes for strings
- `prefer_relative_imports: true` - Use relative imports within lib/
- `always_put_required_named_parameters_first: true`
- `sort_constructors_first: true`

## Key Patterns

### Adding a New Feature
1. Create feature folder under `lib/features/personal/` or `lib/features/business/`
2. Add domain layer: entities, repository interface, use cases
3. Add data layer: models, repository implementation, API/local sources
4. Add view layer: screens, widgets, provider
5. Register dependencies in `lib/services/get_it.dart`
6. Add provider to `lib/services/app_providers.dart`
7. Add route in `lib/routes/app_routes.dart`

### Adding a Socket Handler
1. Create handler class extending `BaseSocketHandler` in feature's `data/sources/socket/`
2. Implement `supportedEvents` getter and `handleEvent` method
3. Register in `lib/services/get_it.dart` and add to `SocketHandlerRegistry`

### String Constants
All string constants, API endpoints, and asset paths are in `lib/core/utilities/app_string.dart`

## Development Notes

- The app supports both light and dark themes (system-aware in `lib/core/theme/`)
- Real-time features via Socket.IO with auto-reconnect
- Payment processing via Flutter Stripe
- Auth tokens stored encrypted, auto-refresh via `TokenRefreshScheduler`
<<<<<<< HEAD
- Custom widgets in `lib/core/widgets/` (40+ reusable components)
=======
- Custom widgets in `lib/core/widgets/` (40+ reusable components)
- Internationalization support via `easy_localization` package
- Firebase integration for push notifications and messaging
- Native splash screen configuration in pubspec.yaml with light/dark theme support
>>>>>>> e947def20999a92448313553bb695b63691bc934
