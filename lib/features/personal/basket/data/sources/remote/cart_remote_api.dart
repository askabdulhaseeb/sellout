import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/param/cart_item_update_qty_param.dart';
import '../../../domain/param/get_postage_detail_params.dart';
import '../../../domain/param/submit_shipping_param.dart';
import '../../models/cart/cart_item_model.dart';
import '../../models/cart/cart_model.dart';
import '../../models/cart/postage_Detail_response_model.dart';
import '../local/local_cart.dart';

abstract interface class CartRemoteAPI {
  Future<DataState<CartEntity>> getCart();
  Future<void> addProductToCart();
  Future<DataState<bool>> removeProductFromCart(String itemID);
  Future<void> clearCart();
  Future<DataState<bool>> updateQty(CartItemUpdateQtyParam param);
  Future<DataState<bool>> updateStatus(
      CartItemModel params, CartItemType action);
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
      GetPostageDetailParam param);
  Future<DataState<bool>> addShipping(SubmitShippingParam param);
}

class CartRemoteAPIImpl implements CartRemoteAPI {
  @override
  Future<DataState<CartEntity>> getCart() async {
    try {
      //
      const String endpoint = '/cart/get';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );
      if (result is DataSuccess<bool>) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataSuccess<CartEntity>(raw, CartModel());
        }
        final CartModel cartModel = CartModel.fromRaw(raw);
        AppLog.info(
          'CartRemoteAPIImpl.getCart - Cart Item: ${cartModel.cartItems.length} - Total: ${cartModel.items.length}',
          name: 'CartRemoteAPIImpl.getCart - Success',
        );
        await LocalCart().save(cartModel);
        return DataSuccess<CartEntity>(raw, cartModel);
      } else {
        AppLog.error(
          'Failed to get cart',
          name: 'CartRemoteAPIImpl.getCart - Else',
        );
        return DataFailer<CartEntity>(CustomException('Failed to get cart'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.getCart - Catch',
        error: e,
      );
      return DataFailer<CartEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<void> addProductToCart() async {
    try {
      //
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.addProductToCart - Catch',
        error: e,
      );
    }
    // TODO: implement addProductToCart
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() async {
    try {
      //
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.clearCart - Catch',
        error: e,
      );
    }
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<DataState<bool>> removeProductFromCart(String itemID) async {
    try {
      final String endpoint = '/cart/remove/$itemID';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
      );
      if (result is DataSuccess<bool>) {
        await LocalCart().removeFromCart(itemID);
        return result;
      } else {
        AppLog.error(
          'Failed to remove product from cart',
          name: 'CartRemoteAPIImpl.removeProductFromCart - Else',
          error: CustomException('Failed to remove product from cart'),
        );
        return DataFailer<bool>(
            CustomException('Failed to remove product from cart'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.removeProductFromCart - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> updateStatus(
    CartItemModel params,
    CartItemType action,
  ) async {
    try {
      final String endpoint =
          '/cart/update/${params.cartItemID}?action=${action.action}';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        // body: action == CartItemType.cart ? params.moveTocart() : null,
      );
      if (result is DataSuccess<bool>) {
        await LocalCart().updateStatus(params, action);
        return result;
      } else {
        AppLog.error(
          'Failed to update status',
          name: 'CartRemoteAPIImpl.updateStatus - Else',
          error: CustomException('Failed to update status'),
        );
        return DataFailer<bool>(CustomException('Failed to update status'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.updateStatus - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> updateQty(CartItemUpdateQtyParam param) async {
    try {
      final String endpoint =
          '/cart/update/${param.cartItem.cartItemID}?action=update_qty';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: param.updateQTY(),
      );
      if (result is DataSuccess<bool>) {
        await LocalCart().updateQTY(param.cartItem, param.qty);
        return result;
      } else {
        AppLog.error(
          'Failed to update QTY',
          name: 'CartRemoteAPIImpl.updateQty - Else',
          error: CustomException('Failed to update QTY'),
        );
        return DataFailer<bool>(CustomException('Failed to update QTY'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.updateQty - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
      GetPostageDetailParam param) async {
    try {
      debugPrint(LocalAuth.token);
      const String endpoint = '/cart/get/postage';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: param.toJson(),
      );
      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty postage response',
            name: 'CartRemoteAPIImpl.getPostageDetails - Empty',
          );
          return DataFailer<PostageDetailResponseModel>(
              CustomException('Empty postage details response'));
        }

        final Map<String, dynamic> json =
            (jsonDecode(raw) is Map<String, dynamic>)
                ? jsonDecode(raw) as Map<String, dynamic>
                : <String, dynamic>{};

        final PostageDetailResponseModel model =
            PostageDetailResponseModel.fromJson(json);
        AppLog.info(model.toJson().toString());
        AppLog.info('Fetched postage details',
            name: 'CartRemoteAPIImpl.getPostageDetails - Success');
        return DataSuccess<PostageDetailResponseModel>(raw, model);
      } else {
        AppLog.error(
          param.toJson(),
          name: 'CartRemoteAPIImpl.getPostageDetails - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<PostageDetailResponseModel>(
            CustomException('Failed to get postage details'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CheckoutRemoteAPIImpl.getPostageDetails - Catch',
        error: e,
      );
      return DataFailer<PostageDetailResponseModel>(
          CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> addShipping(SubmitShippingParam param) async {
    try {
      const String endpoint = '/cart/add/shipping';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: jsonEncode(param.toJson()),
      );
      if (result is DataSuccess<bool>) {
        AppLog.info('Shipping added successfully',
            name: 'CartRemoteAPIImpl.addShipping - Success');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          jsonEncode(param.toJson()),
          name: 'CartRemoteAPIImpl.addShipping - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<bool>(
            result.exception ?? CustomException('Failed to add shipping'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.addShipping - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
