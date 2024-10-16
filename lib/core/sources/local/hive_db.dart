import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../features/attachment/domain/entities/attachment_entity.dart';
import '../../../features/personal/auth/signin/data/models/address_model.dart';
import '../../../features/personal/auth/signin/data/models/current_user_model.dart';
import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../entities/api_request_entity.dart';
import 'local_request_history.dart';

class HiveDB {
  static Future<void> init() async {
    // await LocalState.init();
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    await Hive.initFlutter();

    // Hive
    Hive.registerAdapter(CurrentUserEntityAdapter()); // 0
    // Hive.registerAdapter(MessageEntityAdapter()); // 1
    // Hive.registerAdapter(MessageSenderTypeAdapter()); // 2
    Hive.registerAdapter(ApiRequestEntityAdapter()); // 3
    Hive.registerAdapter(AttachmentEntityAdapter()); // 4
    Hive.registerAdapter(AttachmentTypeAdapter()); // 5
    Hive.registerAdapter(AddressEntityAdapter()); // 6
    // Hive box Open
    await refresh();
  }

  static Future<void> refresh() async {
    await LocalAuth().refresh();
    // await LocalUser().refresh();
    await LocalRequestHistory().refresh();
  }
}
