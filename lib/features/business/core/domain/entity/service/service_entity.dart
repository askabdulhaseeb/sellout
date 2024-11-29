import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../business_employee_entity.dart';
part 'service_entity.g.dart';

@HiveType(typeId: 46)
class ServiceEntity {
  ServiceEntity({
    required this.businessID,
    required this.serviceID,
    required this.name,
    required this.employeesID,
    required this.employees,
    required this.currency,
    required this.isMobileService,
    required this.startAt,
    required this.category,
    required this.model,
    required this.type,
    required this.price,
    required this.listOfReviews,
    required this.time,
    required this.createdAt,
    required this.attachments,
  });

  @HiveField(0)
  final String businessID;
  @HiveField(1)
  final String serviceID;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final List<String> employeesID;
  @HiveField(4)
  final List<BusinessEmployeeEntity> employees;
  @HiveField(5)
  final String currency;
  @HiveField(6)
  final bool isMobileService;
  @HiveField(7)
  final bool startAt;
  @HiveField(8)
  final String category;
  @HiveField(9)
  final String model;
  @HiveField(10)
  final String type;
  @HiveField(11)
  final double price;
  @HiveField(12)
  final List<double> listOfReviews;
  @HiveField(13)
  final int time;
  @HiveField(14)
  final DateTime createdAt;
  @HiveField(15, defaultValue: <AttachmentEntity>[])
  final List<AttachmentEntity> attachments;

  String? get thumbnailURL =>
      attachments.isEmpty ? null : attachments.first.url;
  // final List<ServiceReport> serviceReports;
}
