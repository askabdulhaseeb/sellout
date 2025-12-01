import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/cart/cart_entity.dart';
import '../../models/cart/cart_item_model.dart';
export '../../../domain/entities/cart/cart_entity.dart';

class LocalCart {
  static final String boxTitle = AppStrings.localCartBox;
  static Box<CartEntity> get _box => Hive.box<CartEntity>(boxTitle);

  static Future<Box<CartEntity>> get openBox async =>
      await Hive.openBox<CartEntity>(boxTitle);

  Future<Box<CartEntity>> refresh() async {
    if (Hive.isBoxOpen(boxTitle)) {
      return _box;
    }
    try {
      return await Hive.openBox<CartEntity>(boxTitle);
    } catch (e) {
      // If there's a type mismatch (schema change), delete and recreate the box
      debugPrint('LocalCart: Error opening box, deleting corrupted data: $e');
      try {
        await Hive.deleteBoxFromDisk(boxTitle);
      } catch (deleteError) {
        debugPrint('LocalCart: Error deleting box from disk: $deleteError');
      }
      return await Hive.openBox<CartEntity>(boxTitle);
    }
  }

  Future<void> save(CartEntity user) async {
    await _box.clear();
    await _box.put(user.cartID, user);
  }

  Future<void> clear() async => await _box.clear();

  CartEntity entity(String value) {
    try {
      return _box.values.firstWhere(
        (CartEntity element) => element.cartID == value,
        orElse: () => CartModel(),
      );
    } catch (e) {
      // Type mismatch error - clear corrupted data
      debugPrint('LocalCart.entity: Type error, clearing cart: $e');
      _box.clear();
      return CartModel();
    }
  }

  DataState<CartEntity?> state(String value) {
    try {
      final CartEntity? entity = _box.get(value);
      if (entity != null) {
        return DataSuccess<CartEntity?>(value, entity);
      } else {
        return DataFailer<CartEntity?>(CustomException('Loading...'));
      }
    } catch (e) {
      // Type mismatch error - clear corrupted data
      debugPrint('LocalCart.state: Type error, clearing cart: $e');
      _box.clear();
      return DataFailer<CartEntity?>(CustomException('Cart data corrupted, cleared'));
    }
  }

  Future<void> updateQTY(CartItemEntity item, int qty) async {
    try {
      if (qty <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      final String me = LocalAuth.uid ?? '';
      if (me.isEmpty) {
        throw Exception('User not authenticated');
      }

      final CartEntity currentCart = entity(me);
      final int itemIndex = currentCart.items.indexWhere(
        (CartItemEntity element) => element.cartItemID == item.cartItemID,
      );

      if (itemIndex == -1) {
        throw Exception('Cart item not found');
      }

      currentCart.items[itemIndex].quantity = qty;
      await save(currentCart);
    } catch (e) {
      rethrow; // Re-throw to allow caller to handle
    }
  }

  Future<void> updateStatus(
    CartItemEntity item,
    CartItemStatusType type,
  ) async {
    try {
      final String me = LocalAuth.uid ?? '';
      if (me.isEmpty) {
        throw Exception('User not authenticated');
      }

      final CartEntity currentCart = entity(me);
      final int itemIndex = currentCart.items.indexWhere(
        (CartItemEntity element) => element.cartItemID == item.cartItemID,
      );

      if (itemIndex == -1) {
        throw Exception('Cart item not found');
      }

      currentCart.items[itemIndex].status = type;
      await save(currentCart);
    } catch (e) {
      rethrow; // Re-throw to allow caller to handle
    }
  }

  Future<void> removeFromCart(String itemID) async {
    try {
      if (itemID.isEmpty) {
        throw Exception('Invalid item ID');
      }

      final String me = LocalAuth.uid ?? '';
      if (me.isEmpty) {
        throw Exception('User not authenticated');
      }

      final CartEntity currentCart = entity(me);
      final int initialLength = currentCart.items.length;
      currentCart.items.removeWhere(
        (CartItemEntity element) => element.cartItemID == itemID,
      );

      if (currentCart.items.length == initialLength) {
        throw Exception('Cart item not found');
      }

      await save(currentCart);
    } catch (e) {
      rethrow; // Re-throw to allow caller to handle
    }
  }

  ValueListenable<Box<CartEntity>> listenable() => _box.listenable();
}
