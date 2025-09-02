import 'dart:convert';

class ShareInChatParams {
  ShareInChatParams({
    required this.text,
    required this.shareType,
    required this.endPointChatType,
    this.receiverIds,
    this.groupId,
  });
  final List<String>? receiverIds;
  final String text;
  final String shareType;
  final List<String>? groupId;
  final String? endPointChatType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (endPointChatType == 'private') 'receiver_id': jsonEncode(receiverIds),
      if (endPointChatType == 'group') 'group_id': jsonEncode(groupId),
      'text': text,
      'share_type': shareType,
      'source': 'share',
      'business_id': 'null'
    };
  }
}
