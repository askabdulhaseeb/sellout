import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../services/app_data_services.dart';
import '../../../domain/entities/current_user_entity.dart';
import '../../../../../../../core/utilities/app_string.dart';
export '../../../domain/entities/current_user_entity.dart';

class LocalAuth {
  static final String boxTitle = AppStrings.localAuthBox;
  static Box<CurrentUserEntity> get _box =>
      Hive.box<CurrentUserEntity>(boxTitle);

  static final ValueNotifier<String?> uidNotifier = ValueNotifier<String?>(uid);

  static Future<Box<CurrentUserEntity>> get openBox async =>
      await Hive.openBox<CurrentUserEntity>(boxTitle);

  Future<Box<CurrentUserEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    return isOpen ? _box : await Hive.openBox<CurrentUserEntity>(boxTitle);
  }

  Future<void> signin(CurrentUserEntity currentUser) async {
    await _box.put(boxTitle, currentUser);
    uidNotifier.value = currentUser.userID;
    await AppDataService().fetchAllData();
  }

  static CurrentUserEntity? get currentUser =>
      _box.isEmpty ? null : _box.get(boxTitle);

  static String? get token => currentUser?.token;
  static String? get uid => currentUser?.userID;
  static String get currency => currentUser?.currency ?? 'gbp';
  static LatLng get latlng => LatLng(
      currentUser?.location?.latitude ?? 51.509865,
      currentUser?.location?.longitude ?? -0.118092);

  static Future<void> updateToken(String? token) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) {
      return;
    }

    if (token == null || token.isEmpty || token == existing.token) {
      return;
    }

    final CurrentUserEntity updated = existing.copyWith(token: token);
    await _box.put(boxTitle, updated);
  }

  Future<void> signout() async {
    await _box.clear();
    uidNotifier.value = null; // ✅ notify socket to disconnect
  }
}
