import 'dart:convert';

import '../../../../../attachment/domain/entities/picked_attachment.dart';

class CreateChatParams {
  CreateChatParams({
    required this.recieverId,
    required this.type,
    this.attachments = const <PickedAttachment>[],
    this.groupTitle = '',
    this.groupDescription = '',
  });

  final String type;
  final List<String> recieverId;
  final List<PickedAttachment> attachments;
  final String groupTitle;
  final String groupDescription;

  Map<String, String> toMap() {
    final Map<String, String> map = <String, String>{
      'type':type,
      'receiver_id':jsonEncode(recieverId),
      'source':'Mobile Application',
    };
    if (type == 'group') {
      map['title'] = groupTitle;
      map['description'] = groupDescription;
    }
    return map;
  }
}
