import 'dart:convert';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../domain/entities/current_user_entity.dart';
import 'address_model.dart';
export '../../domain/entities/current_user_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel({
    required super.message,
    required super.token,
    required super.userID,
    //
    required super.email,
    required super.username,
    required super.currency,
    required super.privacy,
    required super.countryAlpha3,
    required super.countryCode,
    required super.phoneNumber,
    required super.language,
    //
    required super.address,
    //
    required super.chatIDs,
    required super.businessIDs,
    //
    required super.imageVerified,
    required super.verificationImage,
    required super.profileImage,
    //
    required super.lastLoginTime,
    required super.createdAt,
  }) : super(inHiveAt: DateTime.now());

  factory CurrentUserModel.fromRawJson(String str) =>
      CurrentUserModel.fromJson(json.decode(str));

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> addressData = json['address'] ?? <dynamic>[];
    final List<AddressEntity> addressList = <AddressEntity>[];
    for (dynamic element in addressData) {
      addressList.add(AddressModel.fromJson(element));
    }
    return CurrentUserModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      userID: json['user_id'] ?? '',
      //
      email: json['email'] ?? '',
      username: json['user_name'] ?? '',
      currency: json['currency'] ?? 'gbp',
      privacy: PrivacyType.fromJson(json['profile_type']),
      countryAlpha3: json['country_alpha_3'] ?? '',
      countryCode: json['country_code'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      language: json['language'] ?? 'en',
      //
      address: addressList,
      //
      chatIDs: List<String>.from((json['chat_ids'] ?? <dynamic>[]).map(
        (dynamic x) => x.toString(),
      )),
      businessIDs: List<String>.from((json['business_ids'] ?? <dynamic>[]).map(
        (dynamic x) => x.toString(),
      )),
      //
      imageVerified: json['image_verified'] ?? false,
      verificationImage: json['verification_pic'] == null
          ? null
          : AttachmentModel.fromJson(json['verification_pic']),
      profileImage: List<AttachmentModel>.from(
          (json['profile_pic'] ?? <dynamic>[])
              .map((dynamic x) => AttachmentModel.fromJson(x))),
      //
      lastLoginTime:
          json['last_login_time']?.toString().toDateTime() ?? DateTime.now(),
      createdAt: json['created_at']?.toString().toDateTime() ?? DateTime.now(),
    );
  }
}
