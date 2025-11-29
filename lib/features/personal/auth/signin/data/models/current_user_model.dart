import 'dart:convert';
import 'address_model.dart';
import 'login_info_model.dart';
import 'login_detail_model.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/login_info_entity.dart';
import '../../domain/entities/current_user_entity.dart';
export '../../domain/entities/current_user_entity.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../user/profiles/data/models/supporter_detail_model.dart';
import '../../../../../business/core/data/models/business_employee_model.dart';
import '../../../../setting/setting_dashboard/data/models/time_away_model.dart';
import '../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../../setting/setting_dashboard/data/models/notification_model.dart';
import '../../../../setting/setting_dashboard/data/models/privacy_setting_model.dart';

class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel({
    required super.message,
    required super.token,
    required super.refreshToken,
    required super.userID,
    required super.email,
    required super.userName,
    required super.displayName,
    required super.bio,
    required super.currency,
    required super.privacyType,
    required super.countryAlpha3,
    required super.countryCode,
    required super.phoneNumber,
    required super.language,
    required super.address,
    required super.chatIDs,
    required super.businessIDs,
    required super.imageVerified,
    required super.otpVerified,
    required super.verificationImage,
    required super.profileImage,
    required super.lastLoginTime,
    required super.createdAt,
    required super.updatedAt,
    required super.businessStatus,
    required super.businessName,
    required super.businessID,
    required super.logindetail,
    required super.loginActivity,
    required super.employeeList,
    required super.twoStepAuthEnabled,
    required super.supporters,
    required super.supporting,
    required super.notification,
    required super.accountType,
    required super.dob,
    required super.saved,
    required super.privacySettings,
    required super.timeAway,
    required super.accountStatus,
    required super.listOfReviews,
    required super.location,
  }) : super(inHiveAt: DateTime.now());

  factory CurrentUserModel.fromRawJson(String str) =>
      CurrentUserModel.fromJson(json.decode(str));

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['item'] ?? <String, dynamic>{};
    final dynamic addressData = userData['address'];

    List<AddressEntity> addressList = <AddressEntity>[];
    if (addressData is List) {
      addressList = addressData.map((e) => AddressModel.fromJson(e)).toList();
    } else if (addressData is Map<String, dynamic>) {
      addressList.add(AddressModel.fromJson(addressData));
    }

    return CurrentUserModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      userID: userData['user_id'] ?? userData['owner_id'] ?? '',
      email: userData['email'] ?? userData['owner_email'] ?? '',
      otpVerified: userData['otp_verified'] ?? false,
      userName: userData['user_name'] ?? '',
      displayName: userData['display_name'] ?? '',
      bio: userData['bio'] ?? '',
      currency: userData['currency'] ?? 'gbp',
      accountStatus: userData['account_status'] ?? '',
      listOfReviews: _parseListOfReviews(userData['list_of_reviews']),
      privacyType: PrivacyType.fromJson(userData['profile_type']),
      countryAlpha3: userData['country_alpha_3'] ?? '',
      countryCode: userData['country_code'] ?? '',
      phoneNumber: userData['phone_number'] ?? '',
      language: userData['language'] ?? 'en',
      address: addressList,
      chatIDs: List<String>.from((userData['chat_ids'] ?? <dynamic>[])
          .map((dynamic e) => e.toString())),
      businessIDs: List<String>.from((userData['business_ids'] ?? <dynamic>[])
          .map((dynamic e) => e.toString())),
      imageVerified: userData['image_verified'] ?? false,
      verificationImage: userData['verification_pic'] != null
          ? AttachmentModel.fromJson(userData['verification_pic'])
          : null,
      profileImage: List<AttachmentModel>.from(
        (userData['profile_pic'] ?? <dynamic>[])
            .map((x) => AttachmentModel.fromJson(x)),
      ),
      lastLoginTime: userData['last_login_time']?.toString().toDateTime() ??
          DateTime.now(),
      createdAt:
          userData['created_at']?.toString().toDateTime() ?? DateTime.now(),
      updatedAt:
          userData['updated_at']?.toString().toDateTime() ?? DateTime.now(),
      businessStatus: userData['business_status']?.toString() ?? '',
      businessName: userData['business_name']?.toString() ?? '',
      businessID: userData['business_id'] ?? '',
      logindetail: LoginDetailModel.fromJson(json['login_detail']),
      loginActivity: (userData['login_activity'] as List<dynamic>?)
              ?.map((e) => DeviceLoginInfoModel.fromJson(e))
              .toList() ??
          <DeviceLoginInfoEntity>[],
      notification: userData['notifications'] != null
          ? NotificationSettingsModel.fromMap(userData['notifications'])
          : null,
      location:
          (userData.containsKey('location') && userData['location'] != null)
              ? LocationModel.fromJson(userData['location'])
              : null,
      employeeList: List<BusinessEmployeeModel>.from(
        (userData['employees'] ?? <dynamic>[])
            .map((e) => BusinessEmployeeModel.fromJson(e)),
      ),
      twoStepAuthEnabled:
          userData['security']?['two_factor_authentication'] ?? false,
      supporters: (userData['supporters'] as List<dynamic>?)
              ?.map((e) => SupporterDetailModel.fromMap(e).toEntity())
              .toList() ??
          <SupporterDetailEntity>[],
      supporting: (userData['supporting'] as List<dynamic>?)
              ?.map((e) => SupporterDetailModel.fromMap(e).toEntity())
              .toList() ??
          <SupporterDetailEntity>[],
      accountType: userData['account_type'] ?? 'personal',
      dob: userData['dob'] != null ? DateTime.tryParse(userData['dob']) : null,
      saved: List<String>.from((userData['saved'] ?? <dynamic>[])),
      privacySettings: userData['privacy'] != null
          ? PrivacySettingsModel.fromJson(userData['privacy'])
          : PrivacySettingsModel.fromJson(json),
      timeAway: userData['time_away'] != null
          ? TimeAwayModel.fromJson(userData['time_away'])
          : null,
    );
  }

  /// Safely parses the list of reviews, converting numeric values to double.
  static List<double> _parseListOfReviews(dynamic reviewsData) {
    if (reviewsData is! List) return <double>[];

    return reviewsData.map((dynamic e) {
      if (e is int) return e.toDouble();
      if (e is double) return e;
      if (e is String) return double.tryParse(e) ?? 0.0;
      return 0.0;
    }).toList();
  }
}
