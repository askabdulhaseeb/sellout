import 'dart:convert';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../auth/signin/data/models/address_model.dart';

import '../../domain/entities/user_entity.dart';
import 'supporter_detail_model.dart';
import 'user_role_info_business_model.dart';
import 'user_support_info_model.dart';
export '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.mobileNo,
    required super.createdAt,
    required super.chatIds,
    required super.timestamp,
    required super.address,
    required super.email,
    required super.uid,
    required super.displayName,
    required super.interest,
    required super.date,
    required super.otpExpiry,
    required super.businessIds,
    required super.supporters,
    required super.listOfReviews,
    required super.profilePic,
    required super.userName,
    required super.profileType,
    required super.saved,
    required super.chatIDs,
    required super.userRoleInfoInBusiness,
    required super.suppotersInfo,
    required super.supportingsInfo,
    required super.phoneNumber,
    required super.updateAt,
  }) : super(inHiveAt: DateTime.now());

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        mobileNo: json['mobile_no'] ?? '',
        createdAt: json['created_at'] == null
            ? DateTime.now()
            : (json['created_at']?.toString().toDateTime()) ?? DateTime.now(),
        chatIds: List<String>.from(
            (json['chat_ids'] ?? <dynamic>[]).map((dynamic x) => x)),
        timestamp:
            (json['timestamp']?.toString().toDateTime()) ?? DateTime.now(),
        address: List<AddressModel>.from((json['address'] ?? <dynamic>[])
            .map((dynamic x) => AddressModel.fromJson(x))),
        email: json['email'] ?? '',
        uid: json['uid'] ?? '',
        displayName: json['display_name'] ?? '',
        interest: List<dynamic>.from(
            (json['interest'] ?? <dynamic>[]).map((dynamic x) => x)),
        date: (json['date']?.toString().toDateTime()) ?? DateTime.now(),
        otpExpiry:
            (json['otp_expiry']?.toString().toDateTime()) ?? DateTime.now(),
        businessIds: List<String>.from(
            (json['business_ids'] ?? <dynamic>[]).map((dynamic x) => x)),
        supporters: List<SupporterDetailModel>.from(
            (json['supporters'] ?? <dynamic>[])
                .map((dynamic x) => SupporterDetailModel.fromMap(x))),
        listOfReviews: List<double>.from(
            (json['list_of_reviews'] ?? <dynamic>[])
                .map((dynamic x) => x?.toDouble())),
        profilePic: List<AttachmentModel>.from(
            (json['profile_pic'] ?? <dynamic>[])
                .map((dynamic x) => AttachmentModel.fromJson(x))),
        userName: json['user_name'] ?? '',
        profileType: PrivacyType.fromJson(json['profile_type']),
        saved: List<String>.from(
            (json['saved'] ?? <dynamic>[]).map((dynamic x) => x)),
        chatIDs: List<String>.from(
            (json['chat_ids'] ?? <dynamic>[]).map((dynamic x) => x)),
        userRoleInfoInBusiness: List<UserRoleInfoInBusinessModel>.from(
            (json['business_map'] ?? <dynamic>[]).map(
          (dynamic x) => UserRoleInfoInBusinessModel.fromMap(x),
        )),
        suppotersInfo: List<UserSupportInfoModel>.from(
            (json['supporters'] ?? <dynamic>[]).map(
          (dynamic x) => UserSupportInfoModel.fromMap(x),
        )),
        supportingsInfo: List<UserSupportInfoModel>.from(
            (json['supporting'] ?? <dynamic>[]).map(
          (dynamic x) => UserSupportInfoModel.fromMap(x),
        )),
        phoneNumber: json['phone_number'] ?? '',
        updateAt: json['update_at'] == null
            ? DateTime.now()
            : (json['update_at']?.toString().toDateTime()) ?? DateTime.now(),
      );
}
