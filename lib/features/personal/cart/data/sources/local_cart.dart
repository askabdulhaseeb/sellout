import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../models/cart/cart_item_model.dart';
export '../../domain/entities/cart/cart_entity.dart';

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

  Future<void> save(CartEntity user) async {
    await _box.clear();
    await _box.put(user.cartID, user);
  }

  Future<void> clear() async => await _box.clear();

  CartEntity entity(String value) => _box.values.firstWhere(
        (CartEntity element) => element.cartID == value,
        orElse: () => CartModel(),
      );

  DataState<CartEntity?> state(String value) {
    final CartEntity? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<CartEntity?>(value, entity);
    } else {
      return DataFailer<CartEntity?>(CustomException('Loading...'));
    }
  }

  Future<void> updateQTY(CartItemEntity item, int qty) async {
    final String me = LocalAuth.uid ?? '';
    final CartEntity currentt = entity(me);
    final CartItemEntity current = currentt.items.firstWhere(
        (CartItemEntity element) => element.cartItemID == item.cartItemID);
    current.quantity = qty;
    await save(currentt);
  }

  Future<void> updateStatus(CartItemEntity item, CartItemType type) async {
    final String me = LocalAuth.uid ?? '';
    final CartEntity currentt = entity(me);
    final CartItemEntity current = currentt.items.firstWhere(
        (CartItemEntity element) => element.cartItemID == item.cartItemID);
    current.status = type.json;
    await save(currentt);
  }

  Future<void> removeFromCart(String itemID) async {
    final String me = LocalAuth.uid ?? '';
    final CartEntity currentt = entity(me);
    currentt.items
        .removeWhere((CartItemEntity element) => element.cartItemID == itemID);
    await save(currentt);
  }

  ValueListenable<Box<CartEntity>> listenable() => _box.listenable();
}
