import '../../../../../../core/extension/string_ext.dart';
import '../../domain/entities/business_profile_detail_entity.dart';

class ProfileBusinessDetailModel extends ProfileBusinessDetailEntity {
  ProfileBusinessDetailModel({
    required super.businessID,
    required super.roleSTR,
    required super.statusSTR,
    required super.addedAt,
  });

  factory ProfileBusinessDetailModel.fromJson(Map<String, dynamic> json) {
    return ProfileBusinessDetailModel(
      businessID: json['business_id'] ?? '',
      roleSTR: json['role'] ?? '',
      statusSTR: json['status'] ?? '',
      addedAt: json['added_at']?.toString().toDateTime() ?? DateTime.now(),
    );
  }
}
