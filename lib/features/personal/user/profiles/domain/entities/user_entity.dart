import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import 'supporter_detail_entity.dart';
import 'user_role_info_business.dart';
import 'user_support_info_entity.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 1)
class UserEntity {
  UserEntity({
    required this.mobileNo,
    required this.createdAt,
    required this.chatIds,
    required this.timestamp,
    required this.address,
    required this.email,
    required this.uid,
    required this.displayName,
    required this.interest,
    required this.date,
    required this.otpExpiry,
    required this.businessIds,
    required this.supporters,
    required this.listOfReviews,
    required this.profilePic,
    required this.userName,
    required this.profileType,
    required this.saved,
    required this.chatIDs,
    required this.userRoleInfoInBusiness,
    required this.suppotersInfo,
    required this.supportingsInfo,
    required this.phoneNumber,
    required this.updateAt,
    required this.inHiveAt,
  });

  @HiveField(0)
  String mobileNo;
  @HiveField(1)
  DateTime createdAt;
  @HiveField(2)
  List<String> chatIds;
  @HiveField(3)
  DateTime timestamp;
  @HiveField(4)
  List<AddressEntity> address;
  @HiveField(5)
  String email;
  @HiveField(6)
  String uid;
  @HiveField(7)
  String displayName;
  @HiveField(8)
  List<dynamic> interest;
  @HiveField(9)
  DateTime date;
  @HiveField(10)
  DateTime otpExpiry;
  @HiveField(11)
  List<String> businessIds;
  @HiveField(12)
  List<SupporterDetailEntity> supporters;
  @HiveField(13)
  List<double> listOfReviews;
  @HiveField(14)
  List<AttachmentEntity> profilePic;
  @HiveField(15)
  String userName;
  @HiveField(16)
  final PrivacyType profileType;
  @HiveField(17, defaultValue: <String>[])
  final List<String> saved;
  @HiveField(18, defaultValue: <String>[])
  final List<String> chatIDs;
  @HiveField(19, defaultValue: <String>[])
  final List<UserRoleInfoInBusinessEntity> userRoleInfoInBusiness;
  @HiveField(20, defaultValue: <String>[])
  final List<UserSupportInfoEntity> suppotersInfo;
  @HiveField(21, defaultValue: <String>[])
  final List<UserSupportInfoEntity> supportingsInfo;
  @HiveField(22, defaultValue: '')
  final String phoneNumber;
  @HiveField(23)
  final DateTime updateAt;
  @HiveField(24)
  final DateTime inHiveAt;

  String? get profilePhotoURL =>
      profilePic.isEmpty ? null : profilePic.first.url;
}
