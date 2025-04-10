class CreatePrivateChatParams {
  CreatePrivateChatParams(
      {required this.recieverId, required this.type, this.businessID});

  String type;
  List<String> recieverId;
  String? businessID;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'receiver_id': recieverId,
      'source': 'App',
      'business_id': businessID,
    };
  }
}
