import '../../../../../attachment/domain/entities/picked_attachment.dart';

class SendMessageParam {
  SendMessageParam({
    required this.chatID,
    required this.text,
    required this.persons,
    required this.files,
    required this.source,
  });

  final String chatID;
  final String text;
  final List<String> persons;
  final List<PickedAttachment> files;
  final String source;

  Map<String, dynamic> _map() {
    return <String, dynamic>{
      'chat_id': chatID,
      if(text.isEmpty)'text':'null',
      'persons': persons,
      'source': source,
    };
  }

  Map<String, String> fieldMap() {
    return _map().map((String key, dynamic value) {
      if (value is List<String>) {
        final List<String> result = value.map((String e) => '"$e"').toList();
        return MapEntry<String, String>(key, '$result');
      } else {
        return MapEntry<String, String>(key, value.toString());
      }
    });
  }
}
