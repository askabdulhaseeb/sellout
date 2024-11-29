import '../../../../../core/extension/string_ext.dart';
import '../../domain/entity/business_employee_entity.dart';

class BusinessEmployeeModel extends BusinessEmployeeEntity {
  BusinessEmployeeModel({
    required super.uid,
    required super.role,
    required super.addBy,
    required super.joinAt,
    required super.chatAt,
    super.source,
    super.status,
  });

  factory BusinessEmployeeModel.fromJson(Map<String, dynamic> json) =>
      BusinessEmployeeModel(
        joinAt: json['join_at']?.toString().toDateTime() ?? DateTime.now(),
        uid: json['uid'] ?? '',
        addBy: json['add_by'] ?? '',
        role: json['role'] ?? '',
        source: json['source'] ?? '',
        chatAt: json['chat_at']?.toString().toDateTime() ?? DateTime.now(),
        status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'join_at': joinAt,
        'uid': uid,
        'add_by': addBy,
        'role': role,
        'source': source,
        'chat_at': chatAt,
        'status': status,
      };
}
