class GetBookingsParams {
  GetBookingsParams({
    this.employeeID,
    this.businessID,
    this.serviceID,
    this.userID,
  });

  final String? employeeID;
  final String? businessID;
  final String? serviceID;
  final String? userID;

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
    if (userID != null) {
      query += 'book_by=$userID&';
    }
    return query;
  }
}
