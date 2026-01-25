import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
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
    required this.isBlocked,
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
  final PrivacyType? privacyType;
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
  @HiveField(75)
  final bool isBlocked;
  @HiveField(99)
  final DateTime inHiveAt;

  UserEntity copyWith({
    String? uid,
    String? email,
    String? username,
    String? displayName,
    String? bio,
    PrivacyType? privacyType,
    List<AttachmentEntity>? profilePic,
    List<AttachmentEntity>? verificationPic,
    bool? isImageVerified,
    String? currency,
    String? language,
    List<double>? listOfReviews,
    String? countryAlpha3,
    String? countryCode,
    String? phoneNumber,
    List<AddressEntity>? address,
    UserStripeAccountEntity? stripeDetails,
    List<String>? chatIDs,
    List<String>? businessIds,
    List<String>? saved,
    List<dynamic>? interest,
    List<SupporterDetailEntity>? supporters,
    List<SupporterDetailEntity>? supportings,
    List<ProfileBusinessDetailEntity>? businessDetail,
    DateTime? date,
    DateTime? updateAt,
    DateTime? otpExpiry,
    DateTime? timestamp,
    DateTime? createdAt,
    bool? isBlocked,
    DateTime? inHiveAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      privacyType: privacyType ?? this.privacyType,
      profilePic: profilePic ?? this.profilePic,
      verificationPic: verificationPic ?? this.verificationPic,
      isImageVerified: isImageVerified ?? this.isImageVerified,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      listOfReviews: listOfReviews ?? this.listOfReviews,
      countryAlpha3: countryAlpha3 ?? this.countryAlpha3,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      stripeDetails: stripeDetails ?? this.stripeDetails,
      chatIDs: chatIDs ?? this.chatIDs,
      businessIds: businessIds ?? this.businessIds,
      saved: saved ?? this.saved,
      interest: interest ?? this.interest,
      supporters: supporters ?? this.supporters,
      supportings: supportings ?? this.supportings,
      businessDetail: businessDetail ?? this.businessDetail,
      date: date ?? this.date,
      updateAt: updateAt ?? this.updateAt,
      otpExpiry: otpExpiry ?? this.otpExpiry,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      inHiveAt: inHiveAt ?? this.inHiveAt,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  String? get profilePhotoURL =>
      profilePic.isEmpty ? null : profilePic.first.url;
}
