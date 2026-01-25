import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../../../core/functions/app_log.dart';

/// Local Hive-based storage for blocked user IDs
class LocalBlockedUsers {
  static const String _boxName = 'blocked_users_box';

  /// Get the Hive box for blocked users
  Future<Box<List>> _getBox() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        return Hive.box<List>(_boxName);
      }
      return await Hive.openBox<List>(_boxName);
    } catch (e) {
      AppLog.error(
        'Error opening blocked users box: $e',
        name: 'LocalBlockedUsers._getBox',
        error: Exception(e),
      );
      rethrow;
    }
  }

  /// Save blocked users list (list of UIDs)
  Future<void> saveBlockedUsers(List<String> blockedUserIds) async {
    try {
      final Box<List> box = await _getBox();
      await box.put('blocked_users', blockedUserIds);
      AppLog.info(
        'Saved ${blockedUserIds.length} blocked users to local cache',
        name: 'LocalBlockedUsers.saveBlockedUsers',
      );
    } catch (e) {
      AppLog.error(
        'Error saving blocked users: $e',
        name: 'LocalBlockedUsers.saveBlockedUsers',
        error: Exception(e),
      );
    }
  }

  /// Get list of blocked user IDs from local cache
  Future<List<String>> getBlockedUsers() async {
    try {
      final Box<List> box = await _getBox();
      final List? blockedUsers = box.get('blocked_users');

      if (blockedUsers == null) {
        return [];
      }

      return List<String>.from(blockedUsers);
    } catch (e) {
      AppLog.error(
        'Error getting blocked users: $e',
        name: 'LocalBlockedUsers.getBlockedUsers',
        error: Exception(e),
      );
      return [];
    }
  }

  /// Check if a user is blocked
  Future<bool> isUserBlocked(String userId) async {
    try {
      final List<String> blockedUsers = await getBlockedUsers();
      return blockedUsers.contains(userId);
    } catch (e) {
      AppLog.error(
        'Error checking if user is blocked: $e',
        name: 'LocalBlockedUsers.isUserBlocked',
        error: Exception(e),
      );
      return false;
    }
  }

  /// Add a user to blocked list
  Future<void> blockUser(String userId) async {
    try {
      final List<String> blockedUsers = await getBlockedUsers();
      if (!blockedUsers.contains(userId)) {
        blockedUsers.add(userId);
        await saveBlockedUsers(blockedUsers);
        AppLog.info(
          'User $userId added to blocked list',
          name: 'LocalBlockedUsers.blockUser',
        );
      }
    } catch (e) {
      AppLog.error(
        'Error blocking user: $e',
        name: 'LocalBlockedUsers.blockUser',
        error: Exception(e),
      );
    }
  }

  /// Remove a user from blocked list
  Future<void> unblockUser(String userId) async {
    try {
      final List<String> blockedUsers = await getBlockedUsers();
      blockedUsers.removeWhere((String id) => id == userId);
      await saveBlockedUsers(blockedUsers);
      AppLog.info(
        'User $userId removed from blocked list',
        name: 'LocalBlockedUsers.unblockUser',
      );
    } catch (e) {
      AppLog.error(
        'Error unblocking user: $e',
        name: 'LocalBlockedUsers.unblockUser',
        error: Exception(e),
      );
    }
  }

  /// Clear all blocked users
  Future<void> clearBlockedUsers() async {
    try {
      final Box<List> box = await _getBox();
      await box.delete('blocked_users');
      AppLog.info(
        'Cleared all blocked users from local cache',
        name: 'LocalBlockedUsers.clearBlockedUsers',
      );
    } catch (e) {
      AppLog.error(
        'Error clearing blocked users: $e',
        name: 'LocalBlockedUsers.clearBlockedUsers',
        error: Exception(e),
      );
    }
  }
}
