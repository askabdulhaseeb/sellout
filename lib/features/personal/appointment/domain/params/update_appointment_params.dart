class UpdateAppointmentParams {
  UpdateAppointmentParams({
    required this.bookingID,
    required this.newStatus,
  });

  final String bookingID;
  final String newStatus;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': newStatus,
      'booking_id': bookingID,
    };
  }

  @override
  String toString() {
    return 'UpdateAppointmentParams(bookingID: $bookingID, newStatus: $newStatus)';
  }
}
