# Push Notification Setup

## Architecture

```
Backend Server → AWS SNS → Firebase FCM → Android/iOS Device
```

---

## Status Summary

| Component | Status |
|-----------|--------|
| Flutter FCM Setup | ✅ Complete |
| Android Config | ✅ Complete |
| iOS Config | ✅ Complete |
| Token retrieval | ✅ Complete |
| Token refresh handling | ✅ Complete |
| FCM token sent in login | ✅ Complete |
| Update token API | ⏳ Waiting for endpoint |
| iOS Xcode capabilities | ❌ Manual step needed |

---

## What's Complete (Flutter Side)

| Feature | File |
|---------|------|
| Firebase initialization | `lib/main.dart` |
| FCM token retrieval | `lib/services/firebase_messaging_service.dart` |
| Token refresh handling | `lib/services/firebase_messaging_service.dart` |
| Foreground notifications | `lib/services/firebase_messaging_service.dart` |
| Background notifications | `lib/main.dart` |
| Notification tap → navigation | `lib/services/firebase_messaging_service.dart` |
| Local notification display | `lib/services/system_notification_service.dart` |
| FCM token in login request | `lib/features/personal/auth/signin/domain/params/device_details.dart` |

---

## How FCM Token is Sent

### On Login

FCM token is sent as `device_token` in the `login_info` object:

```json
POST /userAuth/login

Body:
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
    "device_token": "fcm_token_here..."   // <-- FCM Token
  }
}
```

---

## Backend API Required

### Update FCM Token API (on token refresh)

**When called**: When FCM token refreshes (happens automatically)

**Request**:
```json
PUT /api/user/fcm-token/update

Headers:
  Authorization: Bearer <user_token>
  Content-Type: application/json

Body:
{
  "fcm_token": "newToken123...",
  "user_id": "user_123",
  "platform": "android" | "ios"
}
```

---

## What Flutter Still Needs

### 1. Add update endpoint to `.env` files

Once backend provides the endpoint:

```env
# In dev.env and prod.env
FCM_TOKEN_UPDATE_ENDPOINT=/api/user/fcm-token/update
```

### 2. iOS: Add Push Notification capability in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target → **Signing & Capabilities**
3. Add **Push Notifications** capability
4. Add **Background Modes** → Check "Remote notifications"

---

## Notification Payload Format

Backend should send notifications in this format:

### Chat
```json
{
  "notification": { "title": "New Message", "body": "John: Hello!" },
  "data": { "type": "chat", "chat_id": "123" }
}
```

### Order
```json
{
  "notification": { "title": "Order Update", "body": "Order shipped" },
  "data": { "type": "order", "order_id": "456", "for": "buyer" }
}
```

### Post
```json
{
  "notification": { "title": "New Like", "body": "John liked your post" },
  "data": { "type": "post", "post_id": "789" }
}
```

### Supported Types
| type | Navigates to | Required fields |
|------|--------------|-----------------|
| `chat` | Chat Screen | `chat_id` |
| `order` | Order Screen | `order_id`, `for` |
| `post` | Post Detail | `post_id` |
| other | Notifications Screen | - |

---

## Questions for Backend

1. What is the **update** API endpoint for token refresh?
2. Confirm you're reading `device_token` from `login_info`?
3. What notification types will you send?
