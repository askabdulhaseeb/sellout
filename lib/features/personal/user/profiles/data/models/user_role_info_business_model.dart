import '../../../../../../core/extension/string_ext.dart';
import '../../domain/entities/user_role_info_business.dart';

class UserRoleInfoInBusinessModel extends UserRoleInfoInBusinessEntity {
  UserRoleInfoInBusinessModel({
    required super.businessID,
    required super.role,
    required super.addedAt,
    required super.status,
  });

  factory UserRoleInfoInBusinessModel.fromMap(Map<String, dynamic> map) {
    return UserRoleInfoInBusinessModel(
      businessID: map['business_id'] ?? '',
      role: map['role'] ?? '',
      addedAt: map['added_at']?.toString().toDateTime() ?? DateTime.now(),
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'business_id': businessID,
      'role': role,
      'added_at': addedAt.toIso8601String(),
      'status': status,
    };
  }
}
