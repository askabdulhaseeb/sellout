import '../../../core/domain/entity/service/service_entity.dart';

class ServicesListResponceEntity {
  ServicesListResponceEntity({
    required this.message,
    required this.nextKey,
    required this.services,
  });

  final String message;
  final String? nextKey;
  final List<ServiceEntity> services;
}
