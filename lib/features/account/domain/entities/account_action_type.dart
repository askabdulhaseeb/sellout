import 'package:easy_localization/easy_localization.dart';

enum AccountActionType { deactivate, delete }

extension AccountActionTypeExtension on AccountActionType {
  String get displayName {
    switch (this) {
      case AccountActionType.deactivate:
        return 'deactivate_account'.tr();
      case AccountActionType.delete:
        return 'delete_account'.tr();
    }
  }

  String get description {
    switch (this) {
      case AccountActionType.deactivate:
        return 'deactivate_account_description'.tr();
      case AccountActionType.delete:
        return 'delete_account_description'.tr();
    }
  }

  bool get isReversible {
    return this == AccountActionType.deactivate;
  }
}
