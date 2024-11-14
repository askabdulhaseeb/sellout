import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import 'supporter_detail_entity.dart';

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

  String? get profilePhotoURL =>
      profilePic.isEmpty ? null : profilePic.first.url;
}
