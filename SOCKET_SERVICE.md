# Socket Service Architecture

This document describes the modular socket service architecture used in the Sellout app.

## Overview

The socket service uses a **Handler Registry Pattern** for clean separation of concerns:
- **SocketService**: Thin connection manager (~170 lines)
- **SocketHandlerRegistry**: Dynamic event handler registration
- **Feature Handlers**: Domain-specific handlers in their respective feature folders

## Directory Structure

```
lib/
├── core/sockets/
│   ├── socket_service.dart              # Connection manager
│   └── handlers/
│       ├── base_socket_handler.dart     # Abstract base class
│       ├── socket_handler_registry.dart # Dynamic registration
│       └── presence_handler.dart        # Cross-cutting (online/offline)
│
└── features/personal/
    ├── chats/chat_dashboard/data/sources/socket/
    │   └── chat_socket_handler.dart     # Messages, pinned, upload progress
    │
    ├── payment/data/sources/socket/
    │   └── wallet_socket_handler.dart   # Wallet, payout, onboarding
    │
    └── notifications/data/source/socket/
        └── notification_socket_handler.dart  # Notifications, booking updates
```

## Socket Events

### Incoming Events (Server → Client)

| Event | Handler | Description |
|-------|---------|-------------|
| `getOnlineUsers` | PresenceHandler | Initial list of online users |
| `userOnline` | PresenceHandler | User came online |
| `userOffline` | PresenceHandler | User went offline with lastSeen |
| `lastSeen` | PresenceHandler | Last seen timestamp |
| `newMessage` | ChatSocketHandler | New chat message received |
| `updatedMessage` | ChatSocketHandler | Message was updated |
| `newPinnedMessage` | ChatSocketHandler | New pinned message |
| `updatePinnedMessage` | ChatSocketHandler | Pinned message updated |
| `uploadProgress` | ChatSocketHandler | File upload progress |
| `wallet-updated` | WalletSocketHandler | Wallet balance changed |
| `payout-status-updated` | WalletSocketHandler | Payout status changed |
| `onboarding-success` | WalletSocketHandler | Stripe onboarding complete |
| `new-notification` | NotificationSocketHandler | New notification |

### Outgoing Events (Client → Server)

| Event | Method | Description |
|-------|--------|-------------|
| `joinChat` | `socketService.joinChat(chatId)` | User opened chat screen |
| `leaveChat` | `socketService.leaveChat(chatId)` | User left chat screen |
| Custom | `socketService.emit(event, data)` | Emit any custom event |

## Usage Examples

### Accessing Handlers via GetIt

```dart
// Get presence handler for online status
final PresenceHandler presenceHandler = locator<PresenceHandler>();

// Check if user is online
final bool isOnline = presenceHandler.isUserOnline(userId);

// Listen to online users
ValueListenableBuilder<List<String>>(
  valueListenable: presenceHandler.onlineUsers,
  builder: (context, onlineUsers, _) {
    return Text('Online: ${onlineUsers.length}');
  },
);
```

### Chat Upload Progress

```dart
final ChatSocketHandler chatHandler = locator<ChatSocketHandler>();

// Listen to upload progress
ValueListenableBuilder<Map<String, UploadProgressData>>(
  valueListenable: chatHandler.uploadProgressNotifier,
  builder: (context, progressMap, _) {
    final progress = progressMap[messageId];
    if (progress == null) return const SizedBox();
    return LinearProgressIndicator(value: progress.progress);
  },
);
```

### Emitting Events

```dart
final SocketService socketService = locator<SocketService>();

// Join/leave chat
socketService.joinChat(chatId);
socketService.leaveChat(chatId);

// Custom event
socketService.emit('customEvent', {'key': 'value'});
```

### Creating a Custom Handler

```dart
import 'package:your_app/core/sockets/handlers/base_socket_handler.dart';

class MyCustomHandler extends BaseSocketHandler {
  @override
  List<String> get supportedEvents => <String>['my-event', 'another-event'];

  @override
  Future<void> handleEvent(String eventName, dynamic data) async {
    switch (eventName) {
      case 'my-event':
        // Handle event
        break;
      case 'another-event':
        // Handle event
        break;
    }
  }

  @override
  void dispose() {
    // Cleanup if needed
  }
}
```

### Dynamic Handler Registration

```dart
// Register at runtime
final registry = locator<SocketHandlerRegistry>();
final myHandler = MyCustomHandler();
registry.registerHandler(myHandler);

// Unregister when done
registry.unregisterHandler(myHandler);
```

## Handler Responsibilities

### PresenceHandler (Core)
- Maintains `onlineUsers` ValueNotifier
- Maintains `lastSeenMap` ValueNotifier
- Provides `isUserOnline(userId)` helper

### ChatSocketHandler (Feature)
- Saves new messages to Hive
- Updates existing messages
- Handles pinned messages
- Tracks upload progress via `uploadProgressNotifier`
- Auto-cleans completed uploads after 2 seconds

### WalletSocketHandler (Feature)
- Updates wallet balance locally
- Updates payout status
- Updates Stripe connect account on onboarding success

### NotificationSocketHandler (Feature)
- Saves notifications to Hive
- Shows system push notification
- Updates booking metadata if present

## Event Constants

All socket event names are defined in `lib/core/utilities/app_string.dart`:

```dart
static String get newMessage => 'newMessage';
static String get updatedMessage => 'updatedMessage';
static String get getOnlineUsers => 'getOnlineUsers';
static String get newNotification => 'new-notification';
static String get lastSeen => 'lastSeen';
static String get userOnline => 'userOnline';
static String get userOffline => 'userOffline';
static String get walletUpdated => 'wallet-updated';
static String get payoutStatusUpdated => 'payout-status-updated';
static String get onboardingSuccess => 'onboarding-success';
static String get updatePinnedMessage => 'update-pinned-message';
static String get newPinnedMessage => 'new-pinned-message';
static String get joinChat => 'joinChat';
static String get leaveChat => 'leaveChat';
static String get uploadProgress => 'uploadProgress';
```

## Connection Lifecycle

1. **Initialization**: `SocketService.initAndListen()` called in `main.dart`
2. **Auth Listener**: Automatically connects when user logs in (UID set)
3. **Connection**: Establishes WebSocket connection with `entity_id` query param
4. **Handler Registration**: All handlers from registry are registered on socket
5. **Reconnection**: Auto-reconnects (10 attempts, 2s delay)
6. **Disconnect**: Automatically disconnects when user logs out (UID cleared)

## Best Practices

1. **Keep handlers focused**: One handler per domain
2. **Use ValueNotifiers**: For reactive UI updates
3. **Handle errors gracefully**: Log errors, don't crash
4. **Clean up resources**: Implement `dispose()` in handlers
5. **Use constants**: Define event names in AppStrings
6. **Feature co-location**: Keep handlers in their feature folders
