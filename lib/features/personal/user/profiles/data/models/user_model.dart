import 'dart:convert';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/business_profile_detail_entity.dart';
import '../../domain/entities/supporter_detail_entity.dart';
import '../../domain/entities/user_entity.dart';
import 'business_profile_detail_model.dart';
import 'supporter_detail_model.dart';
import 'user_stripe_account_model.dart';
export '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.username,
    required super.displayName,
    required super.bio,
    required super.privacyType,
    required super.profilePic,
    required super.isImageVerified,
    required super.verificationPic,
    required super.currency,
    required super.language,
    required super.listOfReviews,
    required super.countryAlpha3,
    required super.countryCode,
    required super.phoneNumber,
    //
    required super.address,
    required super.stripeDetails,
    //
    required super.chatIDs,
    required super.businessIds,
    //
    required super.saved,
    required super.interest,
    required super.supporters,
    required super.supportings,
    required super.businessDetail,
    //
    required super.date,
    required super.updateAt,
    required super.otpExpiry,
    required super.timestamp,
    required super.createdAt,
  }) : super(inHiveAt: DateTime.now());

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    username: json['user_name'] ?? '',
    displayName: json['display_name'] ?? '',
    bio: json['bio'] ?? '',
    privacyType: PrivacyType.fromJson(json['profile_type'] ?? 'public'),
    profilePic: List<AttachmentModel>.from(
      (json['profile_pic'] ?? <dynamic>[]).map(
        (dynamic x) => AttachmentModel.fromJson(x),
      ),
    ),
    isImageVerified:
        bool.tryParse(json['image_verified']?.toString() ?? 'false') ?? false,
    verificationPic: List<AttachmentModel>.from(
      (json['verification_pic'] ?? <dynamic>[]).map(
        (dynamic x) => AttachmentModel.fromJson(x),
      ),
    ),
    currency: json['currency'] ?? 'gbp',
    language: json['language'] ?? 'en',
    listOfReviews: List<double>.from(
      (json['list_of_reviews'] ?? <dynamic>[]).map(
        (dynamic x) => x?.toDouble(),
      ),
    ),
    countryAlpha3: json['country_alpha_3'] ?? '',
    countryCode: json['country_code'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
    //
    address: List<AddressModel>.from(
      (json['address'] ?? <dynamic>[]).map(
        (dynamic x) => AddressModel.fromJson(x),
      ),
    ),
    stripeDetails: json['stripe_connect_account'] == null
        ? null
        : UserStripeAccountModel.fromMap(json['stripe_connect_account']),
    //
    chatIDs: List<String>.from(
      (json['chat_ids'] ?? <dynamic>[]).map((dynamic x) => x),
    ),
    businessIds: List<String>.from(
      (json['business_ids'] ?? <dynamic>[]).map((dynamic x) => x),
    ),
    //
    saved: List<String>.from(
      (json['saved'] ?? <dynamic>[]).map((dynamic x) => x),
    ),
    interest: List<dynamic>.from(
      (json['interest'] ?? <dynamic>[]).map((dynamic x) => x),
    ),
    supporters:
        (json['supporters'] as List<dynamic>?)
            ?.map((e) => SupporterDetailModel.fromMap(e).toEntity())
            .toList() ??
        <SupporterDetailEntity>[],
    supportings:
        (json['supporting'] as List<dynamic>?)
            ?.map((e) => SupporterDetailModel.fromMap(e).toEntity())
            .toList() ??
        <SupporterDetailEntity>[],
    businessDetail: json['business_map'] == null
        ? <ProfileBusinessDetailModel>[]
        : List<ProfileBusinessDetailEntity>.from(
            (json['business_map'] ?? <dynamic>[]).map(
              (dynamic e) => ProfileBusinessDetailModel.fromJson(e),
            ),
          ),
    //
    date: (json['date']?.toString().toDateTime()) ?? DateTime.now(),
    updateAt: json['update_at'] == null
        ? DateTime.now()
        : (json['update_at']?.toString().toDateTime()) ?? DateTime.now(),
    otpExpiry: (json['otp_expiry']?.toString().toDateTime()) ?? DateTime.now(),
    timestamp: (json['timestamp']?.toString().toDateTime()) ?? DateTime.now(),
    createdAt: json['created_at'] == null
        ? DateTime.now()
        : (json['created_at']?.toString().toDateTime()) ?? DateTime.now(),
 );

}
