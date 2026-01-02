# Push Notification Setup

## Status

| Component | Status |
|-----------|--------|
| Firebase initialization | ✅ Complete |
| FCM token retrieval | ✅ Complete |
| FCM token sent on login | ✅ Complete |
| Token refresh → update API | ⏳ Waiting for endpoint |
| Foreground notifications | ✅ Complete |
| Background notifications | ✅ Complete |
| Notification tap navigation | ✅ Complete |
| iOS Xcode capabilities | ❌ Manual step |

---

## App Implementation

### 1. Firebase Initialization (`lib/main.dart`)

```dart
// In main()
await Firebase.initializeApp();
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// After first frame
await FirebaseMessagingService().init();
```

### 2. FCM Service (`lib/services/firebase_messaging_service.dart`)

**On init:**
- Requests notification permission
- Gets FCM token and stores in `_fcmToken`
- Sets up listeners for foreground messages, notification taps, and token refresh

**Handlers:**
- `_handleForegroundMessage` → Shows local notification via `SystemNotificationService`
- `_handleMessageOpenedApp` → Navigates to appropriate screen based on `type`
- `_onTokenRefresh` → Calls update API (endpoint needed)

### 3. FCM Token in Login (`lib/features/personal/auth/signin/domain/params/device_details.dart`)

FCM token is included in `login_info.device_token` when user logs in:

```dart
final String? fcmToken = FirebaseMessagingService().fcmToken;
// ...
'device_token': fcmToken ?? '',
```

---

## Communication with Backend

### On Login

**Endpoint:** `POST /userAuth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "****",
  "login_info": {
    "device_id": "abc123",
    "device_name": "Pixel 7",
    "device_type": "Mobile",
    "os": "Android 14",
    "app_version": 1.0,
    "platform": "Android",
    "language": "en_US",
    "device_token": "fcm_token_here..."
  }
}
```

### On App Restart (TODO)

**When called:** When mobile app starts and FCM token has changed (old token expired)

**Endpoint:** `FCM_TOKEN_ENDPOINT` from `.env` (default: `/api/user/fcm-token`)

**Request Body:**
```json
{
  "fcm_token": "new_token...",
  "user_id": "user_123",
  "platform": "android"
}
```

**Note:** Backend needs to provide this endpoint to update expired tokens.

---

## Receiving Notifications from Backend

Backend sends notifications via AWS SNS → FCM. App expects this payload format:

### Payload Structure
```json
{
  "notification": {
    "title": "Notification Title",
    "body": "Notification message"
  },
  "data": {
    "type": "chat|order|post",
    "chat_id": "123",
    "order_id": "456",
    "post_id": "789",
    "for": "buyer|seller"
  }
}
```

### Navigation Based on `type`

| `type` | Screen | Required `data` fields |
|--------|--------|------------------------|
| `chat` | ChatScreen | `chat_id` |
| `order` | OrderBuyerScreen / OrderSellerScreen | `order_id`, `for` |
| `post` | PostDetailScreen | `post_id` |
| (other) | NotificationsScreen | - |

---

## Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Firebase init, background handler registration |
| `lib/services/firebase_messaging_service.dart` | FCM token, message handling, navigation |
| `lib/services/system_notification_service.dart` | Local notification display |
| `lib/features/personal/auth/signin/domain/params/device_details.dart` | Includes FCM token in login |
| `android/app/google-services.json` | Android Firebase config |
| `ios/Runner/GoogleService-Info.plist` | iOS Firebase config |

---

## TODO

1. **Backend:** Provide token update API endpoint for token refresh
2. **App:** Add `FCM_TOKEN_UPDATE_ENDPOINT` to `.env` once provided
3. **iOS:** Add Push Notification capability in Xcode:
   - Open `ios/Runner.xcworkspace`
   - Runner target → Signing & Capabilities
   - Add "Push Notifications"
   - Add "Background Modes" → Remote notifications
