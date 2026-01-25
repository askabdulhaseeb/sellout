# Get Blocked Users Use Case

## Overview
This use case implements the API endpoint `/user/blocked` to fetch the list of users that the current user has blocked.

## Architecture

### 1. **Use Case Layer** 
**File:** [lib/features/personal/user/profiles/domain/usecase/get_blocked_users_usecase.dart](lib/features/personal/user/profiles/domain/usecase/get_blocked_users_usecase.dart)

```dart
class GetBlockedUsersUsecase implements UseCase<List<UserEntity>, void>
```

- **Type Parameter:** `<List<UserEntity>, void>`
  - Returns: `DataState<List<UserEntity>>` - List of blocked users
  - Input: `void` - No parameters needed

### 2. **Repository Interface** 
**File:** [lib/features/personal/user/profiles/domain/repositories/user_repositories.dart](lib/features/personal/user/profiles/domain/repositories/user_repositories.dart)

Added method to abstract interface:
```dart
Future<DataState<List<UserEntity>>> getBlockedUsers();
```

### 3. **Repository Implementation** 
**File:** [lib/features/personal/user/profiles/data/repositories/user_repository_impl.dart](lib/features/personal/user/profiles/data/repositories/user_repository_impl.dart)

Delegates to remote data source:
```dart
@override
Future<DataState<List<UserEntity>>> getBlockedUsers() async {
  return await userProfileRemoteSource.getBlockedUsers();
}
```

### 4. **Remote Data Source** 
**File:** [lib/features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart](lib/features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart)

#### Interface:
```dart
abstract interface class UserProfileRemoteSource {
  Future<DataState<List<UserEntity>>> getBlockedUsers();
}
```

#### Implementation:
- **Endpoint:** `GET /user/blocked`
- **Authentication:** Required (isAuth: true)
- **Response Handling:**
  - Supports direct list response: `[{user1}, {user2}...]`
  - Supports nested responses: `{data: [...]}`, `{blocked_users: [...]}`, `{users: [...]}`
- **Parsing:** Uses `UserModel.fromJson()` to convert JSON to UserEntity objects
- **Error Handling:** Comprehensive logging with AppLog
- **Status Codes:** Returns success if API returns successful response, failure otherwise

## Usage Example

```dart
// Inject the use case
final getBlockedUsersUsecase = GetBlockedUsersUsecase(userProfileRepository);

// Call the use case
final DataState<List<UserEntity>> result = await getBlockedUsersUsecase(null);

// Handle result
if (result is DataSuccess) {
  final List<UserEntity> blockedUsers = result.entity;
  print('Found ${blockedUsers.length} blocked users');
  
  for (final user in blockedUsers) {
    print('${user.displayName} (${user.uid})');
  }
} else if (result is DataFailer) {
  print('Error: ${result.exception?.message}');
}
```

## API Response Format

The API endpoint expects to return blocked users in one of these formats:

### Direct List:
```json
[
  {
    "uid": "user1",
    "email": "user1@example.com",
    "user_name": "john_doe",
    "display_name": "John Doe",
    ...
  },
  {
    "uid": "user2",
    "email": "user2@example.com",
    ...
  }
]
```

### Nested Response:
```json
{
  "data": [
    { "uid": "user1", ... },
    { "uid": "user2", ... }
  ]
}
```

Or:
```json
{
  "blocked_users": [
    { "uid": "user1", ... },
    { "uid": "user2", ... }
  ]
}
```

## Features

✅ **Full Error Handling** - Catches and logs parsing errors, API errors, and exceptions  
✅ **Type Safety** - Properly typed with Dart generics  
✅ **Logging** - Comprehensive AppLog calls for debugging  
✅ **Flexibility** - Supports multiple response formats  
✅ **Authentication** - Requires authenticated requests  
✅ **User Entity Mapping** - Converts JSON to proper UserEntity objects  

## Files Modified

1. ✅ Created [lib/features/personal/user/profiles/domain/usecase/get_blocked_users_usecase.dart](lib/features/personal/user/profiles/domain/usecase/get_blocked_users_usecase.dart)
2. ✅ Updated [lib/features/personal/user/profiles/domain/repositories/user_repositories.dart](lib/features/personal/user/profiles/domain/repositories/user_repositories.dart)
3. ✅ Updated [lib/features/personal/user/profiles/data/repositories/user_repository_impl.dart](lib/features/personal/user/profiles/data/repositories/user_repository_impl.dart)
4. ✅ Updated [lib/features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart](lib/features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart)

## Related Files

- **Entity:** [lib/features/personal/user/profiles/domain/entities/user_entity.dart](lib/features/personal/user/profiles/domain/entities/user_entity.dart)
- **Model:** [lib/features/personal/user/profiles/data/models/user_model.dart](lib/features/personal/user/profiles/data/models/user_model.dart)
- **Local User Cache:** [lib/features/personal/user/profiles/data/sources/local/local_user.dart](lib/features/personal/user/profiles/data/sources/local/local_user.dart)

## Conventions Followed

✅ Clean Architecture (Domain → Data)  
✅ Repository Pattern  
✅ Use Case Pattern  
✅ DataState for error/success handling  
✅ AppLog for structured logging  
✅ Consistent naming conventions  
✅ Comprehensive error handling  
✅ Type safety with generics
