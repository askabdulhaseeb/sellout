import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import 'encryption_key_manager.dart';

abstract class LocalHiveBox<T> {
  LocalHiveBox();

  String get boxName;
  Box<T> get box => Hive.box<T>(boxName);

  /// Override this to return true for boxes containing sensitive data.
  /// Sensitive boxes will be encrypted with AES-256.
  bool get requiresEncryption => false;

  Future<Box<T>> refresh() async {
    if (Hive.isBoxOpen(boxName)) return box;

    try {
      if (requiresEncryption) {
        final Uint8List encryptionKey =
            await EncryptionKeyManager.getEncryptionKey();
        return await Hive.openBox<T>(
          boxName,
          encryptionCipher: HiveAesCipher(encryptionKey),
        );
      }
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      debugPrint(
        'LocalHiveBox: Error opening "$boxName". Deleting corrupted box. Error: $e',
      );

      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (deleteError) {
        debugPrint(
          'LocalHiveBox: Failed to delete corrupted box "$boxName". Error: $deleteError',
        );
      }

      if (requiresEncryption) {
        final Uint8List encryptionKey =
            await EncryptionKeyManager.getEncryptionKey();
        return await Hive.openBox<T>(
          boxName,
          encryptionCipher: HiveAesCipher(encryptionKey),
        );
      }
      return await Hive.openBox<T>(boxName);
    }
  }

  Future<void> clear() async {
    try {
      await box.clear();
    } catch (e) {
      debugPrint('LocalHiveBox: Error clearing box "$boxName". Error: $e');

      try {
        await Hive.deleteBoxFromDisk(boxName);
        await Hive.openBox<T>(boxName);
      } catch (deleteError) {
        debugPrint(
          'LocalHiveBox: Failed to delete box "$boxName". Error: $deleteError',
        );
      }
    }
  }

  Future<void> save(String key, T value) async {
    await box.put(key, value);
  }

  Future<void> saveAll(Map<String, T> values) async {
    await box.putAll(values);
  }

  T? get(String key) => box.get(key);

  List<T> getAll() => box.values.toList();

  Future<void> delete(String key) async {
    await box.delete(key);
  }

  bool containsKey(String key) => box.containsKey(key);

  int get length => box.length;

  Stream<BoxEvent> watch() => box.watch();
}
