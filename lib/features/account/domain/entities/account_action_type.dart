enum AccountActionType { deactivate, delete }

extension AccountActionTypeExtension on AccountActionType {
  String get displayName {
    switch (this) {
      case AccountActionType.deactivate:
        return 'Deactivate Account';
      case AccountActionType.delete:
        return 'Delete Account';
    }
  }

  String get description {
    switch (this) {
      case AccountActionType.deactivate:
        return 'Take a break from SellOut. Your profile and data will be hidden but preserved. You can reactivate anytime and everything will be restored.';
      case AccountActionType.delete:
        return 'Permanently delete your SellOut account and all associated data. This action cannot be undone. All your posts, messages, and profile will be gone forever.';
    }
  }

  bool get isReversible {
    return this == AccountActionType.deactivate;
  }
}
