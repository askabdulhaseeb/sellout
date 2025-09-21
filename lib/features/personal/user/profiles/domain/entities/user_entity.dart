import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import 'business_profile_detail_entity.dart';
import 'supporter_detail_entity.dart';
import 'user_stripe_account_entity.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 1)
class UserEntity {
  UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.privacyType,
    required this.profilePic,
    required this.isImageVerified,
    required this.verificationPic,
    required this.currency,
    required this.language,
    required this.listOfReviews,
    required this.countryAlpha3,
    required this.countryCode,
    required this.phoneNumber,
    //
    required this.address,
    required this.stripeDetails,
    //
    required this.chatIDs,
    required this.businessIds,
    //
    required this.saved,
    required this.interest,
    required this.supporters,
    required this.supportings,
    required this.businessDetail,
    //
    required this.date,
    required this.updateAt,
    required this.otpExpiry,
    required this.timestamp,
    required this.createdAt,
    required this.inHiveAt,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String displayName;
  @HiveField(4)
  final String bio;
  @HiveField(5)
  final PrivacyType privacyType;
  @HiveField(6)
  final List<AttachmentEntity> profilePic;
  @HiveField(7)
  final List<AttachmentEntity> verificationPic;
  @HiveField(8)
  final bool isImageVerified;
  @HiveField(9)
  final String currency;
  @HiveField(10)
  final String language;
  @HiveField(11)
  final List<double> listOfReviews;
  @HiveField(12)
  final String countryAlpha3;
  @HiveField(13)
  final String countryCode;
  @HiveField(14)
  final String phoneNumber;
  //
  @HiveField(30)
  final List<AddressEntity> address;
  //
  @HiveField(40)
  final UserStripeAccountEntity? stripeDetails;
  //
  //
  @HiveField(50)
  final List<String> chatIDs;
  @HiveField(51)
  final List<String> businessIds;
  //
  @HiveField(60)
  final List<String> saved;
  @HiveField(61)
  final List<dynamic> interest;
  @HiveField(62)
  final List<SupporterDetailEntity>? supporters;
  @HiveField(63)
  final List<SupporterDetailEntity>? supportings;
  @HiveField(64)
  final List<ProfileBusinessDetailEntity> businessDetail;
  //
  @HiveField(70)
  final DateTime date;
  @HiveField(71)
  final DateTime updateAt;
  @HiveField(72)
  final DateTime otpExpiry;
  @HiveField(73)
  final DateTime timestamp;
  @HiveField(74)
  final DateTime createdAt;
  @HiveField(99)
  final DateTime inHiveAt;

  String? get profilePhotoURL =>
      profilePic.isEmpty ? null : profilePic.first.url;
}
