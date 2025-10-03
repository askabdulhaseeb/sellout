import '../../data/models/service_employee_model.dart';
import '../entites/service_employee_entity.dart';

class RequestQuoteParams {
  RequestQuoteParams({
    required this.servicesAndEmployees,
    required this.businessId,
  });

  final List<ServiceEmployeeEntity> servicesAndEmployees;
  final String businessId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'services_and_employees': servicesAndEmployees
          .map((ServiceEmployeeEntity e) =>
              ServiceEmployeeModel.fromEntity(e).toMap())
          .toList(),
      'business_id': businessId,
    };
  }
}
