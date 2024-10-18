import '../../../../../../core/extension/string_ext.dart';
import '../../../domain/entities/visit/visiting_detail_entity.dart';
import 'visiting_detail_post_model.dart';

class VisitingDetailModel extends VisitingDetailEntity {
  VisitingDetailModel({
    required super.visitingId,
    required super.post,
    required super.dateTime,
    required super.visiterId,
    required super.visitingTime,
    required super.hostId,
    required super.status,
  });

  factory VisitingDetailModel.fromJson(Map<String, dynamic> json) {
    return VisitingDetailModel(
      visitingId: json['visiting_id'],
      post: VisitingDetailPostModel.fromJson(json['post']),
      dateTime:
          (json['date_time']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      visiterId: json['visiter_id'],
      visitingTime: json['visiting_time'],
      hostId: json['host_id'],
      status: json['status'],
    );
  }
}
