import 'dart:convert';

import '../../../../../attachment/data/attchment_model.dart';
import '../../../../auth/signin/data/models/address_model.dart';

import '../../domain/entities/user_entity.dart';
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
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        mobileNo: json['mobile_no'],
        createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
        chatIds: List<String>.from(json['chat_ids'].map((dynamic x) => x)),
        timestamp:
            DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now(),
        address: List<AddressModel>.from((json['address'] ?? <dynamic>[])
            .map((dynamic x) => AddressModel.fromJson(x))),
        email: json['email'],
        uid: json['uid'],
        displayName: json['display_name'],
        interest: List<dynamic>.from(
            (json['interest'] ?? <dynamic>[]).map((dynamic x) => x)),
        date: DateTime.tryParse(json['date']) ?? DateTime.now(),
        otpExpiry:
            DateTime.tryParse(json['otp_expiry'].toString()) ?? DateTime.now(),
        businessIds: List<String>.from(
            (json['business_ids'] ?? <dynamic>[]).map((dynamic x) => x)),
        supporters: List<String>.from(
            (json['supporters'] ?? <dynamic>[]).map((dynamic x) => x)),
        listOfReviews: List<double>.from(
            (json['list_of_reviews'] ?? <dynamic>[])
                .map((dynamic x) => x?.toDouble())),
        profilePic: List<AttachmentModel>.from(
            (json['profile_pic'] ?? <dynamic>[])
                .map((dynamic x) => AttachmentModel.fromJson(x))),
        userName: json['user_name'],
      );
}
