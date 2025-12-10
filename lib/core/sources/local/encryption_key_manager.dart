import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';

/// Manages the encryption key for Hive boxes using platform-secure storage.
///
/// The encryption key is stored in:
/// - Android: EncryptedSharedPreferences (backed by Android Keystore)
/// - iOS: Keychain Services
class EncryptionKeyManager {
  static const String _encryptionKeyName = 'sellout_hive_encryption_key';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    // aOptions: AndroidOptions(
    //   encryptedSharedPreferences: true,
    // ),
    // iOptions: IOSOptions(
    //   accessibility: KeychainAccessibility.first_unlock_this_device,
    // ),
  );

  static Uint8List? _cachedKey;

  /// Retrieves the encryption key, generating one if it doesn't exist.
  ///
  /// The key is cached in memory for performance after first retrieval.
  static Future<Uint8List> getEncryptionKey() async {
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    final String? existingKey = await _secureStorage.read(
      key: _encryptionKeyName,
    );

    if (existingKey != null) {
      _cachedKey = base64Decode(existingKey);
      return _cachedKey!;
    }

    // Generate a new 256-bit (32 bytes) encryption key
    final List<int> newKey = Hive.generateSecureKey();
    await _secureStorage.write(
      key: _encryptionKeyName,
      value: base64Encode(newKey),
    );

    _cachedKey = Uint8List.fromList(newKey);
    return _cachedKey!;
  }

  /// Checks if an encryption key exists.
  static Future<bool> hasEncryptionKey() async {
    final String? existingKey = await _secureStorage.read(
      key: _encryptionKeyName,
    );
    return existingKey != null;
  }

  /// Deletes the encryption key.
  ///
  /// WARNING: This will make all encrypted Hive boxes unreadable.
  /// Only call this during complete data wipe (e.g., account deletion).
  static Future<void> deleteKey() async {
    _cachedKey = null;
    await _secureStorage.delete(key: _encryptionKeyName);
  }

  /// Clears the cached key from memory.
  ///
  /// The key will be re-read from secure storage on next access.
  static void clearCache() {
    _cachedKey = null;
  }
}
