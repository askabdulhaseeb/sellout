class CreatePrivateChatParams {
  CreatePrivateChatParams({required this.recieverId, this.type = 'private'});

  String? type;
  String recieverId; // Change as per your requirements

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'receiver_id': recieverId,
    };
  }
}
