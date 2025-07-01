import 'dart:convert';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../../business/core/data/models/business_employee_model.dart';
import '../../../../setting/setting_dashboard/data/models/notification_model.dart';
import '../../../../setting/setting_dashboard/data/models/privacy_setting_model.dart';
import '../../../../setting/setting_dashboard/data/models/time_away_model.dart';
import '../../../../user/profiles/data/models/supporter_detail_model.dart';
import '../../domain/entities/current_user_entity.dart';
import 'address_model.dart';
import 'login_detail_model.dart';
import 'login_info_model.dart';
export '../../domain/entities/current_user_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel({
    required super.message,
    required super.token,
    required super.userID,
    required super.email,
    required super.userName,
    required super.displayName,
    required super.currency,
    required super.privacy,
    required super.countryAlpha3,
    required super.countryCode,
    required super.phoneNumber,
    required super.language,
    required super.address,
    required super.chatIDs,
    required super.businessIDs,
    required super.imageVerified,
    required super.verificationImage,
    required super.profileImage,
    required super.lastLoginTime,
    required super.createdAt,
    required super.updatedAt, //No associated named super constructor parameter.Try changing the name to the name of an existing named super constructor parameter, or creating such named parameter.
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
  }) : super(
            inHiveAt: DateTime
                .now()); //The named parameter 'accountStatus' is required, but there's no corresponding argument.Try adding the required argument.dartmissing_required_argumentThe named parameter 'listOfReviews' is required, but there's no corresponding argument.Try adding the required argument.

  factory CurrentUserModel.fromRawJson(String str) =>
      CurrentUserModel.fromJson(json.decode(str));

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['item'] ?? <String, dynamic>{};
    final dynamic addressData = userData['address'];

    List<AddressEntity> addressList = [];
    if (addressData is List) {
      addressList = addressData.map((e) => AddressModel.fromJson(e)).toList();
    } else if (addressData is Map<String, dynamic>) {
      addressList.add(AddressModel.fromJson(addressData));
    }

    return CurrentUserModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      userID: userData['user_id'] ?? userData['owner_id'] ?? '',
      email: userData['email'] ?? userData['owner_email'] ?? '',
      userName: userData['user_name'] ?? '',
      displayName: userData['display_name'] ?? '',
      currency: userData['currency'] ?? 'gbp',
      accountStatus: userData['account_status'] ?? '',
      listOfReviews: List<int>.from(userData['list_of_reviews'] ?? []),
      privacy: PrivacyType.fromJson(userData['profile_type'] ?? 'public'),
      countryAlpha3: userData['country_alpha_3'] ?? '',
      countryCode: userData['country_code'] ?? '',
      phoneNumber: userData['phone_number'] ?? '',
      language: userData['language'] ?? 'en',
      address: addressList,
      chatIDs: List<String>.from(
          (userData['chat_ids'] ?? []).map((e) => e.toString())),
      businessIDs: List<String>.from(
          (userData['business_ids'] ?? []).map((e) => e.toString())),
      imageVerified: userData['image_verified'] ?? false,
      verificationImage: userData['verification_pic'] != null
          ? AttachmentModel.fromJson(userData['verification_pic'])
          : null,
      profileImage: List<AttachmentModel>.from(
        (userData['profile_pic'] ?? []).map((x) => AttachmentModel.fromJson(x)),
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
          [],
      notification: userData['notifications'] != null
          ? NotificationSettingsModel.fromMap(userData['notifications'])
          : null,
      employeeList: List<BusinessEmployeeModel>.from(
        (userData['employees'] ?? [])
            .map((e) => BusinessEmployeeModel.fromJson(e)),
      ),
      twoStepAuthEnabled:
          userData['security']?['two_factor_authentication'] ?? false,
      supporters: (userData['supporters'] as List<dynamic>?)
              ?.map((e) => SupporterDetailModel.fromMap(e).toEntity())
              .toList() ??
          [],
      supporting: (userData['supporting'] as List<dynamic>?)
              ?.map((e) => SupporterDetailModel.fromMap(e).toEntity())
              .toList() ??
          [],
      accountType: userData['account_type'] ?? 'personal',
      dob: userData['dob']?.toString().toDateTime(),
      saved: List<String>.from((userData['saved'] ?? [])),
      privacySettings: userData['privacy'] != null
          ? PrivacySettingsModel.fromJson(userData['privacy'])
          : PrivacySettingsModel.fromJson(json),
      timeAway: userData['time_away'] != null
          ? TimeAwayModel.fromJson(userData['time_away'])
          : null,
    );
  }
}
