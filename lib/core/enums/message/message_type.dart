import 'package:hive_ce/hive.dart';
import '../../functions/app_log.dart';
part 'message_type.g.dart';

@HiveType(typeId: 18)
enum MessageType {
  @HiveField(0)
  text('text', 'text'),
  @HiveField(1)
  image('image', 'image'),
  @HiveField(2)
  video('video', 'video'),
  @HiveField(3)
  audio('audio', 'audio'),
  @HiveField(4)
  file('file', 'file'),
  @HiveField(5)
  location('location', 'location'),
  @HiveField(6)
  contact('contact', 'contact'),
  @HiveField(7)
  sticker('sticker', 'sticker'),
  @HiveField(8)
  custom('custom', 'custom'),
  @HiveField(9)
  invitationParticipant('invitation_participant', 'invitation_participant'),
  @HiveField(10)
  offer('offer', 'offer'),
  @HiveField(11)
  visiting('visiting', 'visiting'),
  @HiveField(12)
  acceptInvitation('accept_invitation', 'accept_invitation'),
  @HiveField(13)
  removeParticipant('remove_participant', 'remove_participant'),
  @HiveField(14)
  leaveGroup('leave_group', 'leave_group'),
  @HiveField(15)
  simple('simple', 'simple'),
  @HiveField(16)
  requestQuote('request_quote', 'request_quote'),
  @HiveField(17)
  quote('quote', 'quote'),
  @HiveField(18)
  inquiry('inquiry', 'inquiry'),
  @HiveField(99)
  none('none', 'none');

  // visiting,
  const MessageType(this.code, this.json);
  final String code;
  final String json;

  static MessageType fromJson(String? value) {
    if (value != null &&
        value != 'invitation_participant' &&
        value != 'accept_invitation' &&
        value != 'remove_participant' &&
        value != 'offer' &&
        value != 'visiting' &&
        value != 'leave_group' &&
        value != 'request_quote' &&
        value != 'quote' &&
        value != 'simple' &&
        value != 'inquiry') {
      AppLog.error(
        'MessageType.fromvalue: $value',
        name: 'MessageType.fromJson - if',
      );
    }
    if (value == null) {
      return MessageType.text;
    }
    return values.firstWhere(
      (MessageType e) => e.json == value,
      orElse: () => MessageType.text,
    );
  }
}
