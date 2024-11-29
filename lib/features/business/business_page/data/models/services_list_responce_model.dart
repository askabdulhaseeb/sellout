import '../../../core/data/models/service/service_model.dart';
import '../../domain/entities/services_list_responce_entity.dart';

class ServicesListResponceModel extends ServicesListResponceEntity {
  ServicesListResponceModel({
    required super.message,
    required super.nextKey,
    required super.services,
  });

  factory ServicesListResponceModel.fromJson(Map<String, dynamic> json) {
    return ServicesListResponceModel(
      message: json['message'] ?? '',
      nextKey: json['nextKey'],
      services: (json['items'] ?? <dynamic>[])
          .map((dynamic e) => ServiceModel.fromJson(e))
          .toList(),
    );
  }
}
