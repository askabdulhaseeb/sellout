class GetServiceSlotsParams {
  GetServiceSlotsParams({
    required this.serviceId,
    required this.date,
    required this.openingTime,
    required this.closingTime,
    this.serviceDuration = 30,
  });
  final String serviceId;
  final DateTime date;
  final String openingTime;
  final String closingTime;
  final int serviceDuration;
}
