import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for authentication credentials using platform Keychain/Keystore.
///
/// This provides an additional layer of security for the most sensitive data:
/// - Auth tokens are stored directly in platform secure storage
/// - Data is automatically deleted on app uninstall (iOS)
/// - Supports biometric authentication (optional)
///
/// Use this alongside encrypted Hive boxes for defense in depth.
class SecureAuthStorage {
  static const String _tokenKey = 'sellout_auth_token';
  static const String _refreshTokenKey = 'sellout_refresh_token';
  static const String _userIdKey = 'sellout_user_id';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    // aOptions: AndroidOptions(
    //   encryptedSharedPreferences: true,
    //   sharedPreferencesName: 'sellout_secure_prefs',
    //   preferencesKeyPrefix: 'sellout_',
    // ),
    // iOptions: IOSOptions(
    //   accessibility: KeychainAccessibility.first_unlock_this_device,
    //   accountName: 'SelloutAuth',
    // ),
  );

  // ─────────────────────────────────────────────────────────────────
  // Auth Token
  // ─────────────────────────────────────────────────────────────────

  /// Saves the auth token securely.
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the auth token.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Checks if an auth token exists.
  static Future<bool> hasToken() async {
    final String? token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Deletes the auth token.
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ─────────────────────────────────────────────────────────────────
  // Refresh Token
  // ─────────────────────────────────────────────────────────────────

  /// Saves the refresh token securely.
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves the refresh token.
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Deletes the refresh token.
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // ─────────────────────────────────────────────────────────────────
  // User ID
  // ─────────────────────────────────────────────────────────────────

  /// Saves the user ID securely.
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Retrieves the user ID.
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Deletes the user ID.
  static Future<void> deleteUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // ─────────────────────────────────────────────────────────────────
  // Bulk Operations
  // ─────────────────────────────────────────────────────────────────

  /// Saves all auth credentials at once.
  static Future<void> saveCredentials({
    required String token,
    String? refreshToken,
    String? userId,
  }) async {
    await saveToken(token);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    if (userId != null) {
      await saveUserId(userId);
    }
  }

  /// Clears all auth credentials (call on logout).
  static Future<void> clearAll() async {
    await Future.wait(<Future<void>>[
      deleteToken(),
      deleteRefreshToken(),
      deleteUserId(),
    ]);
  }

  /// Checks if user is authenticated (has valid token).
  static Future<bool> isAuthenticated() async {
    return await hasToken();
  }

  // ─────────────────────────────────────────────────────────────────
  // Custom Key-Value Storage
  // ─────────────────────────────────────────────────────────────────

  /// Saves a custom secure value.
  static Future<void> saveSecure(String key, String value) async {
    await _storage.write(key: 'sellout_$key', value: value);
  }

  /// Retrieves a custom secure value.
  static Future<String?> getSecure(String key) async {
    return await _storage.read(key: 'sellout_$key');
  }

  /// Deletes a custom secure value.
  static Future<void> deleteSecure(String key) async {
    await _storage.delete(key: 'sellout_$key');
  }
}
