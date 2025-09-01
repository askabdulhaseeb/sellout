class BookServiceParams {
  BookServiceParams({
    required this.servicesAndEmployees,
  });
  final List<ServiceAndEmployee> servicesAndEmployees;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'services_and_employees': servicesAndEmployees
          .map((ServiceAndEmployee service) => service.toMap())
          .toList(),
    };
  }
}

class ServiceAndEmployee {
  ServiceAndEmployee({
    required this.serviceId,
    required this.employeeId,
    required this.bookAt,
  });
  final String serviceId;
  final String employeeId;
  final String bookAt;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_id': serviceId,
      'employee_id': employeeId,
      'book_at': bookAt,
    };
  }
}
