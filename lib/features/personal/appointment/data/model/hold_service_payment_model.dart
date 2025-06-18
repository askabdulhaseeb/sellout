import '../../../../../core/sources/api_call.dart';

class HoldServiceResponse {
  factory HoldServiceResponse.fromJson(String source) =>
      HoldServiceResponse.fromMap(json.decode(source));

  factory HoldServiceResponse.fromMap(Map<String, dynamic> map) {
    return HoldServiceResponse(
      clientSecret: map['clientSecret'] ?? '',
      bookingId: map['booking_id'] ?? '',
      serviceId: map['service_id'] ?? '',
      serviceImage: map['service_image'] ?? '',
    );
  }

  HoldServiceResponse({
    required this.clientSecret,
    required this.bookingId,
    required this.serviceId,
    required this.serviceImage,
  });
  final String clientSecret;
  final String bookingId;
  final String serviceId;
  final String serviceImage;
}
