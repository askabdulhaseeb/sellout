import 'package:hive_ce/hive.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/chat/unread_message_entity.dart';

class LocalUnreadMessagesService extends LocalHiveBox<UnreadMessageEntity> {
   @override
  String get boxName => AppStrings.localUnreadMessages;

  late Box<UnreadMessageEntity> _box;
  bool _isInitialized = false;
  Future<void> init() async {
    if (!_isInitialized) {
      if (!Hive.isAdapterRegistered(55)) {
        Hive.registerAdapter(UnreadMessageEntityAdapter());
      }
      _box = await Hive.openBox<UnreadMessageEntity>(AppStrings.localUnreadMessages);
      _isInitialized = true;
    }
  }

  Future<void> increment(String chatId) async {
    if (!_isInitialized) await init();
    final UnreadMessageEntity? entity = _box.get(chatId);
    if (entity != null) {
      entity.count += 1;
      AppLog.info(
        'unread coount incremented',
        name: 'LocalUnreadMessagesService.increment - if',
      );
      await entity.save();
    } else {
      await _box.put(chatId, UnreadMessageEntity(chatId: chatId, count: 1));
      AppLog.info(
        'unread coount incremented',
        name: 'LocalUnreadMessagesService.increment - else',
      );
    }
  }

  Future<void> clearCount(String chatId) async {
    if (!_isInitialized) await init();
    await _box.put(chatId, UnreadMessageEntity(chatId: chatId, count: 0));
  }

  int getCount(String chatId) {
    if (!_isInitialized) return 0;
    return _box.get(chatId)?.count ?? 0;
  }
}
