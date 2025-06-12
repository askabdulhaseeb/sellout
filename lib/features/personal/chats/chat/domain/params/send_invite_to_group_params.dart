import 'dart:convert';

import 'package:flutter/widgets.dart';

class SendGroupInviteParams {

  factory SendGroupInviteParams.fromMap(Map<String, dynamic> map) {
    return SendGroupInviteParams(
      chatId: map['chat_id'] ?? '',
      newParticipants: List<String>.from(map['new_participants'] ?? <dynamic>[]),
    );
  }

  SendGroupInviteParams({
    required this.chatId,
    required this.newParticipants,
  });
  final String chatId;
  final List<String> newParticipants;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatId,
      'new_participants':newParticipants,
    };
   
  }
}
