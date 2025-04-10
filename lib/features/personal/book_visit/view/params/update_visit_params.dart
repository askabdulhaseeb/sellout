class UpdateVisitParams {
  UpdateVisitParams({
    required this.visitingId,
    required this.messageId,
    required this.chatId,
    this.status,
    this.datetime,
    this.businessId,
  });
  final String visitingId;
  final String? status;
  final String? datetime;
  final String messageId;
  final String? businessId;
  final String? chatId;

  Map<String, dynamic> tocancelvisit() {
    return <String, dynamic>{
      'visiting_id': visitingId,
      'status': status,
      'message_id': messageId,
      'business_id': businessId ?? 'null',
    };
  }

  Map<String, dynamic> toupdatevisit() {
    return <String, dynamic>{
      'visiting_id': visitingId,
      'date_time': datetime,
      'message_id': messageId,
      'business_id': businessId ?? 'null',
    };
  }
}
