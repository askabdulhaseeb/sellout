import 'dart:convert';
import '../../domain/entities/login_detail_entity.dart';

class LoginDetailModel extends LoginDetailEntity {
  LoginDetailModel({required super.type, required super.role});

  factory LoginDetailModel.fromRawJson(String str) =>
      LoginDetailModel.fromJson(json.decode(str));
  factory LoginDetailModel.fromJson(Map<String, dynamic> json) {
    return LoginDetailModel(
      type: json['type'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
