class UpdateAppointmentParams {
  UpdateAppointmentParams({
    required this.bookingID,
    this.newStatus,
    this.bookAt,
    this.apiKey,
  });

  final String bookingID;
  final String? newStatus;
  final String? bookAt;
  final String? apiKey;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (apiKey == 'status') 'status': newStatus,
      if (bookAt != 'booking_time') 'book_at': bookAt,
      'booking_id': bookingID,
    };
  }

  @override
  String toString() {
    return 'UpdateAppointmentParams(bookingID: $bookingID, newStatus: $newStatus)';
  }
}
