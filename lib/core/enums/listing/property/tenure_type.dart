import 'package:easy_localization/easy_localization.dart';

enum TenureType {
  freehold,
  leasehold,
}

extension TenureTypeExtension on TenureType {
  /// Get raw string value for API or storage
  String get value {
    switch (this) {
      case TenureType.freehold:
        return 'freehold';
      case TenureType.leasehold:
        return 'leasehold';
    }
  }

  /// Get localized text for UI
  String get localized => value.tr();

  /// Convert from API JSON (string → enum)
  static TenureType fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'freehold':
        return TenureType.freehold;
      case 'leasehold':
        return TenureType.leasehold;
      default:
        throw ArgumentError('Invalid TenureType: $value');
    }
  }

  /// Convert to API JSON (enum → string)
  String toJson() => value;
}
