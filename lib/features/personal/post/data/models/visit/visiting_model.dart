import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../domain/entities/visit/visiting_entity.dart';

class VisitingModel extends VisitingEntity {
  VisitingModel({
    required super.visitingID,
    required super.visiterID,
    required super.businessID,
    required super.hostID,
    required super.postID,
    required super.status,
    required super.visitingTime,
    required super.dateTime,
    required super.createdAt,
  });

  factory VisitingModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(String dateTimeStr) {
      try {
        return DateFormat('hh:mm a yyyy-MM-dd').parse(dateTimeStr);
      } catch (e) {
        debugPrint('Failed to parse date_time: $dateTimeStr');
        return DateTime.now();
      }
    }

    final String postID = json['post_id'] ?? json['post']['post_id'] ?? '';
    return VisitingModel(
      visitingID: json['visiting_id'] ?? '',
      visiterID: json['visiter_id'] ?? '',
      businessID: json['business_id'] ?? '',
      hostID: json['host_id'] ?? '',
      postID: postID,
      status: StatusType.fromJson(json['status']),
      visitingTime: json['visiting_time'] ?? '',
      dateTime: parseDateTime(json['date_time']),
      createdAt: (json['created_at']?.toString() ?? '').toDateTime(),
    );
  }
}
