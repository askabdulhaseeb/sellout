class RequestQuoteParams {
  RequestQuoteParams({
    required this.servicesAndEmployees,
    required this.businessId,
  });

  factory RequestQuoteParams.fromMap(Map<String, dynamic> map) {
    return RequestQuoteParams(
      servicesAndEmployees: (map['services_and_employees'] as List)
          .map((e) => RequestQuoteServiceParam.fromMap(e))
          .toList(),
      businessId: map['business_id'] ?? '',
    );
  }
  final List<RequestQuoteServiceParam> servicesAndEmployees;
  final String businessId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'services_and_employees': servicesAndEmployees
          .map((RequestQuoteServiceParam e) => e.toMap())
          .toList(),
      'business_id': businessId,
    };
  }
}

class RequestQuoteServiceParam {
  RequestQuoteServiceParam({
    required this.serviceId,
    required this.quantity,
    required this.bookAt,
  });

  factory RequestQuoteServiceParam.fromMap(Map<String, dynamic> map) {
    return RequestQuoteServiceParam(
      serviceId: map['service_id'] ?? '',
      quantity: map['quantity'] ?? 0,
      bookAt: map['book_at'] ?? '',
    );
  }
  final String serviceId;
  final int quantity;
  final String bookAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_id': serviceId,
      'quantity': quantity,
      'book_at': bookAt,
    };
  }
}
