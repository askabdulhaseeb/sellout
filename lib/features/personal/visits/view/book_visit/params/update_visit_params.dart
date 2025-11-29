class UpdateVisitParams {
  UpdateVisitParams({
    required this.visitingId,
    required this.messageId,
    required this.chatId,
    required this.query,
    this.status,
    this.datetime,
    this.businessId,
  });
  final String visitingId;
  final String? status;
  final String? datetime;
  final String? query;
  final String messageId;
  final String? businessId;
  final String? chatId;

  Map<String, dynamic> toupdatevisit() {
    return <String, dynamic>{
      'visiting_id': visitingId,
      if (query == 'status') 'status': status,
      'message_id': messageId,
      if (query == 'date') 'date_time': datetime,
    };
  }
}
