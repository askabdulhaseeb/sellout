import 'dart:convert';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../../business/core/data/models/business_employee_model.dart';
import '../../domain/entities/current_user_entity.dart';
import 'address_model.dart';
import 'login_detail_model.dart';
export '../../domain/entities/current_user_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel(
      {required super.message,
      required super.token,
      required super.userID,
      //
      required super.email,
      required super.userName,
      required super.displayName,
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
      //
      required super.businessStatus, // **Optional - used for Business**
      required super.businessName, // **Optional - used for Business**
      required super.businessID, // **Optional - used for Business**
      required super.logindetail,
      required super.employeeList})
      : super(inHiveAt: DateTime.now());

  factory CurrentUserModel.fromRawJson(String str) =>
      CurrentUserModel.fromJson(json.decode(str));

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['item'] ?? <dynamic, dynamic>{};

    // **Handling address field to support both List and Map**
    final dynamic addressData = userData['address'];
    List<AddressEntity> addressList = <AddressEntity>[];
    if (addressData is List) {
      for (dynamic element in addressData) {
        addressList.add(AddressModel.fromJson(element));
      }
    } else if (addressData is Map<String, dynamic>) {
      addressList.add(AddressModel.fromJson(addressData));
    }

    return CurrentUserModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      userID: userData['user_id'] ?? userData['owner_id'] ?? '',
      //
      email: userData['email'] ?? userData['owner_email'] ?? '',
      userName: userData['user_name'] ?? '',
      displayName: userData['display_name'] ?? '',
      currency: userData['currency'] ?? 'gbp',
      privacy: PrivacyType.fromJson(
          userData['profile_type'] ?? 'public'), // **Handled null**
      countryAlpha3: userData['country_alpha_3'] ?? '',
      countryCode: userData['country_code'] ?? '',
      phoneNumber: userData['phone_number'] ?? '',
      language: userData['language'] ?? 'en',
      //
      address: addressList,
      //
      chatIDs: List<String>.from((userData['chat_ids'] ?? <dynamic>[]).map(
        (dynamic x) => x.toString(),
      )),
      businessIDs:
          List<String>.from((userData['business_ids'] ?? <dynamic>[]).map(
        (dynamic x) => x.toString(),
      )),
      //
      imageVerified: userData['image_verified'] ?? false,
      verificationImage: userData['verification_pic'] == null
          ? null
          : AttachmentModel.fromJson(userData['verification_pic']),
      profileImage: List<AttachmentModel>.from(
          (userData['profile_pic'] ?? <dynamic>[])
              .map((dynamic x) => AttachmentModel.fromJson(x))),
      //
      lastLoginTime: userData['last_login_time']?.toString().toDateTime() ??
          DateTime.now(),
      createdAt:
          userData['created_at']?.toString().toDateTime() ?? DateTime.now(),
      //
      businessStatus: userData['business_status']
          .toString(), // **Optional - used for Business**
      businessName: userData['business_name']
          .toString(), // **Optional - used for Business**
      businessID:
          userData['business_id'] ?? 'null', // **Optional - used for Business**
      logindetail: LoginDetailModel.fromJson(json['login_detail']),
      employeeList: List<BusinessEmployeeModel>.from(
        (userData['employees'] ?? <dynamic>[])
            .map((dynamic e) => BusinessEmployeeModel.fromJson(e)),
      ),
    );
  }
}
