import '../../data/models/service_employee_model.dart';

class RequestQuoteParams {
  RequestQuoteParams({
    required this.servicesAndEmployees,
    required this.businessId,
  });

  factory RequestQuoteParams.fromMap(Map<String, dynamic> map) {
    return RequestQuoteParams(
      servicesAndEmployees: (map['services_and_employees'] as List)
          .map((e) => ServiceEmployeeModel.fromMap(e))
          .toList(),
      businessId: map['business_id'] ?? '',
    );
  }
  final List<ServiceEmployeeModel> servicesAndEmployees;
  final String businessId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'services_and_employees': servicesAndEmployees
          .map((ServiceEmployeeModel e) => e.toMap())
          .toList(),
      'business_id': businessId,
    };
  }
}
