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
    final String postID = json['post_id'] ?? json['post']['post_id'] ?? '';
    return VisitingModel(
      visitingID: json['visiting_id'] ?? '',
      visiterID: json['visiter_id'] ?? '',
      businessID: json['business_id'] ?? '',
      hostID: json['host_id'] ?? '',
      postID: postID,
      status: StatusType.fromJson(json['status']),
      visitingTime: json['visiting_time'] ?? '',
      dateTime:
          (json['date_time']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      createdAt: (json['created_at']?.toString() ?? '').toDateTime(),
    );
  }
}
