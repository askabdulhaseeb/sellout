class LeaveGroupParams {

  LeaveGroupParams({required this.chatId, this.removalType});
  final String chatId;
  final String? removalType;

  Map<String, dynamic> toMap() {
    return {
      'chat_id': chatId,
      if (removalType != null) 'removal_type': removalType,
    };
  }
}
