import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/current_user_entity.dart';
export '../../../domain/entities/current_user_entity.dart';

class LocalAuth {
  static final String boxTitle = AppStrings.localAuthBox;
  static Box<CurrentUserEntity> get _box =>
      Hive.box<CurrentUserEntity>(boxTitle);

  static final ValueNotifier<List<AddressEntity>> addressListNotifier =
      ValueNotifier<List<AddressEntity>>(_getCurrentAddresses());
  static final ValueNotifier<AddressEntity?> sellingAddressNotifier =
      ValueNotifier<AddressEntity?>(currentUser?.sellingAddress);

  static void notifySellingAddressChanged() {
    sellingAddressNotifier.value = currentUser?.sellingAddress;
  }

  static List<AddressEntity> _getCurrentAddresses() {
    return currentUser?.address ?? <AddressEntity>[];
  }

  void _notifyAddressListChanged() {
    addressListNotifier.value = List<AddressEntity>.from(
      _getCurrentAddresses(),
    );
  }

  Future<void> updateOrAddAddress(List<AddressEntity> addresses) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) return;
    final CurrentUserEntity updated = existing.copyWith(address: addresses);
    await _box.put(boxTitle, updated);
    _notifyAddressListChanged();
  }

  /// Updates the address list for the current user and saves it locally.
  Future<void> updateAddress(List<AddressEntity> newAddresses) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) return;
    final CurrentUserEntity updated = existing.copyWith(address: newAddresses);
    await _box.put(boxTitle, updated);
    _notifyAddressListChanged();
  }

  /// Updates the profile picture for the current user and saves it locally.
  Future<void> updateProfilePicture(
    List<AttachmentEntity> newProfileImages,
  ) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) return;
    final CurrentUserEntity updated = existing.copyWith(
      profileImage: newProfileImages,
    );
    await _box.put(boxTitle, updated);
  }

  static final ValueNotifier<String?> uidNotifier = ValueNotifier<String?>(uid);

  static Future<Box<CurrentUserEntity>> get openBox async =>
      await Hive.openBox<CurrentUserEntity>(boxTitle);

  Future<Box<CurrentUserEntity>> refresh() async {
    if (Hive.isBoxOpen(boxTitle)) {
      return Hive.box<CurrentUserEntity>(boxTitle);
    }
    try {
      return await Hive.openBox<CurrentUserEntity>(boxTitle);
    } catch (e) {
      debugPrint('LocalAuth: Error opening box, deleting corrupted data: $e');
      try {
        await Hive.deleteBoxFromDisk(boxTitle);
      } catch (deleteError) {
        debugPrint('LocalAuth: Error deleting box from disk: $deleteError');
      }
      return await Hive.openBox<CurrentUserEntity>(boxTitle);
    }
  }

  Future<void> signin(CurrentUserEntity currentUser) async {
    await _box.put(boxTitle, currentUser);
    uidNotifier.value = currentUser.userID;
    debugPrint('[LocalAuth] Signed in as user: \\${currentUser.userID}');
    notifySellingAddressChanged();
  }

  static CurrentUserEntity? get currentUser =>
      _box.isEmpty ? null : _box.get(boxTitle);
  static String? get token => currentUser?.token;
  static String? get uid => currentUser?.userID;
  static String get currency => currentUser?.currency ?? 'GBP';
  static LatLng get latlng => LatLng(
    currentUser?.location?.latitude ?? 51.509865,
    currentUser?.location?.longitude ?? -0.118092,
  );

  /// Static getter for selling address
  static AddressEntity? get sellingAddress => currentUser?.sellingAddress;

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
    try {
      await _box.clear();
    } catch (e) {
      debugPrint('LocalAuth: Error clearing box during signout: $e');
    }
    uidNotifier.value = null;
  }
}
