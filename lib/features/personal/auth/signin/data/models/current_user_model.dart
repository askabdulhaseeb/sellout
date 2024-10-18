import 'dart:convert';

import '../../domain/entities/current_user_entity.dart';
import 'address_model.dart';
export '../../domain/entities/current_user_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel({
    required super.message,
    required super.email,
    required super.token,
    required super.userName,
    required super.userId,
    required super.address,
    required super.chatIDs,
  });

  factory CurrentUserModel.fromRawJson(String str) =>
      CurrentUserModel.fromJson(json.decode(str));

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> addressData = json['address'] ?? <dynamic>[];
    final List<AddressEntity> addressList = <AddressEntity>[];
    for (dynamic element in addressData) {
      addressList.add(AddressModel.fromJson(element));
    }
    return CurrentUserModel(
      message: json['message'],
      email: json['email'],
      token: json['token'],
      userName: json['user_name'],
      userId: json['user_id'],
      address: addressList,
      chatIDs: List<String>.from((json['chat_ids'] ?? <dynamic>[]).map(
        (dynamic x) => x.toString(),
      )),
    );
  }
}
