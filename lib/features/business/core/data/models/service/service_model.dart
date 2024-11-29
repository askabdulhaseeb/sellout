import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../domain/entity/service/service_entity.dart';
import '../business_employee_model.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.businessID,
    required super.serviceID,
    required super.name,
    required super.employeesID,
    required super.employees,
    required super.currency,
    required super.isMobileService,
    required super.startAt,
    required super.category,
    required super.model,
    required super.type,
    required super.price,
    required super.listOfReviews,
    required super.time,
    required super.createdAt,
    required super.attachments,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        businessID: json['business_id'] ?? '',
        serviceID: json['service_id'] ?? '',
        name: json['service_name'] ?? '',
        currency: json['currency'] ?? '',
        createdAt:
            json['created_at']?.toString().toDateTime() ?? DateTime.now(),
        employees: List<BusinessEmployeeModel>.from(
            (json['employees'] ?? <dynamic>[])
                .map((dynamic x) => BusinessEmployeeModel.fromJson(x))),
        time: int.tryParse(json['time']?.toString() ?? '0') ?? 0,
        isMobileService: json['mobile_service'] ?? false,
        category: json['service_category'] ?? '',
        startAt: json['start_at'] ?? false,
        model: json['service_model'] ?? '',
        employeesID: List<String>.from(
            (json['employees_id'] ?? <dynamic>[]).map((dynamic x) => x)),
        type: json['service_type'] ?? '',
        price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
        listOfReviews: List<double>.from(
          (json['list_of_reviews'] ?? <dynamic>[])
              .map((dynamic x) => double.tryParse(x.toString()) ?? 0.0),
        ),
        attachments: List<AttachmentEntity>.from(
          (json['file_url'] ?? <dynamic>[])
              .map((dynamic x) => AttachmentModel.fromJson(x)),
        ),
        // serviceReports: List<ServiceReport>.from(
        //     json['service_reports'].map((dynamic x) => ServiceReport.fromJson(x))),
      );
}
