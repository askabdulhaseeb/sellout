class GetBusinessBookingsParams {
  GetBusinessBookingsParams({
    this.employeeID,
    this.businessID,
    this.serviceID,
  });

  final String? employeeID;
  final String? businessID;
  final String? serviceID;

  String get query {
    String query = '';
    if (employeeID != null) {
      query += 'employee_id=$employeeID&';
    }
    if (businessID != null) {
      query += 'business_id=$businessID&';
    }
    if (serviceID != null) {
      query += 'service_id=$serviceID&';
    }
    return query;
  }
}
