class LeaveGroupParams {
  LeaveGroupParams(
      {required this.chatId, this.removalType, this.participantId});
  final String chatId;
  final String? removalType;
  final String? participantId;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatId,
      'removal_type': removalType,
      if (participantId != null) 'participant_id': participantId
    };
  }
}
