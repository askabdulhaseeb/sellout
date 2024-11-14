import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../domain/entities/cart_entity.dart';

export '../../domain/entities/cart_entity.dart';

class LocalCart {
  static final String boxTitle = AppStrings.localCartBox;
  static Box<CartEntity> get _box => Hive.box<CartEntity>(boxTitle);

  static Future<Box<CartEntity>> get openBox async =>
      await Hive.openBox<CartEntity>(boxTitle);

  Future<Box<CartEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<CartEntity>(boxTitle);
    }
  }

  Future<void> save(CartEntity user) async => await _box.put(user.cartID, user);
  CartEntity? entity(String value) => _box.get(value);

  DataState<CartEntity?> state(String value) {
    final CartEntity? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<CartEntity?>(value, entity);
    } else {
      return DataFailer<CartEntity?>(CustomException('Loading...'));
    }
  }

  ValueListenable<Box<CartEntity>> listenable() => _box.listenable();
}
