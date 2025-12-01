import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/current_user_entity.dart';
export '../../../domain/entities/current_user_entity.dart';

class LocalAuth extends LocalHiveBox<CurrentUserEntity> {
  @override
  String get boxName => AppStrings.localAuthBox;
  final ValueNotifier<List<AddressEntity>> addressListNotifier =
      ValueNotifier<List<AddressEntity>>(_getCurrentAddressesStatic());

  static List<AddressEntity> _getCurrentAddressesStatic() {
    final Box<CurrentUserEntity>? box = Hive.isBoxOpen(AppStrings.localAuthBox)
        ? Hive.box<CurrentUserEntity>(AppStrings.localAuthBox)
        : null;
    final CurrentUserEntity? user = box?.isEmpty == false
        ? box?.get(AppStrings.localAuthBox)
        : null;
    return user?.address ?? <AddressEntity>[];
  }

  void _notifyAddressListChanged() {
    addressListNotifier.value = List<AddressEntity>.from(
      currentUser?.address ?? <AddressEntity>[],
    );
  }

  Future<void> updateOrAddAddress(List<AddressEntity> addresses) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) return;
    final CurrentUserEntity updated = existing.copyWith(address: addresses);
    await box.put(AppStrings.localAuthBox, updated);
    _notifyAddressListChanged();
  }

  /// Updates the address list for the current user and saves it locally.
  Future<void> updateAddress(List<AddressEntity> newAddresses) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) return;
    final CurrentUserEntity updated = existing.copyWith(address: newAddresses);
    await box.put(AppStrings.localAuthBox, updated);
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
    await box.put(uid, updated);
  }

  static final ValueNotifier<String?> uidNotifier = ValueNotifier<String?>(uid);

  Future<void> signin(CurrentUserEntity currentUser) async {
    await box.put(uid, currentUser);
    uidNotifier.value = currentUser.userID;
  }

  static CurrentUserEntity? get currentUser {
    final Box<CurrentUserEntity>? box = Hive.isBoxOpen(AppStrings.localAuthBox)
        ? Hive.box<CurrentUserEntity>(AppStrings.localAuthBox)
        : null;
    return box?.isEmpty == false ? box?.get(AppStrings.localAuthBox) : null;
  }

  static String? get token => currentUser?.token;
  static String? get uid => currentUser?.userID;
  static String get currency => currentUser?.currency ?? 'GBP';
  static LatLng get latlng => LatLng(
    currentUser?.location?.latitude ?? 51.509865,
    currentUser?.location?.longitude ?? -0.118092,
  );

  Future<void> updateToken(String? token) async {
    final CurrentUserEntity? existing = currentUser;
    if (existing == null) {
      return;
    }

    if (token == null || token.isEmpty || token == existing.token) {
      return;
    }

    final CurrentUserEntity updated = existing.copyWith(token: token);
    await box.put(uid, updated);
  }

  Future<void> signout() async {
    try {
      await box.clear();
    } catch (e) {
      // Ignore errors when clearing box (e.g., PathNotFoundException for lock files)
      debugPrint('LocalAuth: Error clearing box during signout: $e');
    }
    uidNotifier.value = null;
  }
}
