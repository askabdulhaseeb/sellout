import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/app_snakebar.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../data/models/cart/cart_model.dart';
import '../../data/models/checkout/order_billing_model.dart';
import '../../data/sources/local/local_cart.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../domain/entities/checkout/check_out_entity.dart';
import '../../domain/enums/cart_type.dart';
import '../../domain/enums/shopping_basket_type.dart';
import '../../domain/param/cart_item_update_qty_param.dart';
import '../../domain/param/get_postage_detail_params.dart';
import '../../domain/usecase/cart/cart_item_status_update_usecase.dart';
import '../../domain/usecase/cart/cart_update_qty_usecase.dart';
import '../../domain/usecase/cart/get_cart_usecase.dart';
import '../../domain/usecase/cart/get_postage_detail_usecase.dart';
import '../../domain/usecase/cart/remove_from_cart_usecase.dart';
import '../../domain/usecase/checkout/get_checkout_usecase.dart';
import '../../domain/usecase/checkout/pay_intent_usecase.dart';
import '../widgets/checkout/tile/payment_success_bottomsheet.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(
    this._getCartUsecase,
    this._cartItemStatusUpdateUsecase,
    this._removeFromCartUsecase,
    this._cartUpdateQtyUsecase,
    this._getCheckoutUsecase,
    this._payIntentUsecase,
    this._getPostageDetailUsecase,
  );
  // MARK: 🧱  Dependencies
  final GetCartUsecase _getCartUsecase;
  final CartItemStatusUpdateUsecase _cartItemStatusUpdateUsecase;
  final RemoveFromCartUsecase _removeFromCartUsecase;
  final CartUpdateQtyUsecase _cartUpdateQtyUsecase;
  final GetCheckoutUsecase _getCheckoutUsecase;
  final PayIntentUsecase _payIntentUsecase;
  final GetPostageDetailUsecase _getPostageDetailUsecase;

  // MARK: ⚙️ State Variables
  ShoppingBasketPageType _shoppingBasketType = ShoppingBasketPageType.basket;
  CartType _cartType = CartType.shoppingBasket;
  CartItemType _basketPage = CartItemType.cart;

  List<CartItemEntity> _cartItems = <CartItemEntity>[];
  final List<String> _fastDeliveryProducts = <String>[];
  OrderBillingModel? _orderBilling;
  PostageDetailResponseEntity? _postageResponseEntity;
  // selected postage rate per postID
  final Map<String, RateEntity> _selectedPostageRates = <String, RateEntity>{};

  AddressEntity? _address = (LocalAuth.currentUser?.address != null &&
          LocalAuth.currentUser!.address
              .where((AddressEntity e) => e.isDefault)
              .isNotEmpty)
      ? LocalAuth.currentUser!.address
          .where((AddressEntity e) => e.isDefault)
          .first
      : null;

  // MARK: 🧭 Getters
  CartType get cartType => _cartType;
  ShoppingBasketPageType get shoppingBasketType => _shoppingBasketType;
  List<CartItemEntity> get cartItems => _cartItems;
  List<String> get fastDeliveryProducts => _fastDeliveryProducts;
  OrderBillingModel? get orderBilling => _orderBilling;
  PostageDetailResponseEntity? get postageResponseEntity =>
      _postageResponseEntity;
  Map<String, RateEntity> get selectedPostageRates => _selectedPostageRates;
  CartItemType get basketPage => _basketPage;
  AddressEntity? get address => _address;

  // MARK: ✏️ Setters
  void setCartType(CartType type) {
    _cartType = type;
    notifyListeners();
  }

  void setBasketPageType(ShoppingBasketPageType type) {
    _shoppingBasketType = type;
    notifyListeners();
  }

  set basketPage(CartItemType value) {
    _basketPage = value;
    notifyListeners();
  }

  set address(AddressEntity? value) {
    _address = value;
    notifyListeners();
  }

  void addFastDeliveryProduct(String id) {
    if (id.isEmpty) return;
    if (!_fastDeliveryProducts.contains(id)) {
      _fastDeliveryProducts.add(id);
      notifyListeners();
    }
  }

  void removeFastDeliveryProduct(String id) {
    if (id.isEmpty) return;
    if (_fastDeliveryProducts.remove(id)) {
      notifyListeners();
    }
  }

  void toggleFastDeliveryProduct(String id) {
    if (id.isEmpty) return;
    if (_fastDeliveryProducts.contains(id)) {
      _fastDeliveryProducts.remove(id);
    } else {
      _fastDeliveryProducts.add(id);
    }
    notifyListeners();
  }

  void clearFastDeliveryProducts() {
    if (_fastDeliveryProducts.isNotEmpty) {
      _fastDeliveryProducts.clear();
      notifyListeners();
    }
  }

  // MARK: 📦 CART OPERATIONS

  Future<bool> getCart() async {
    if (_cartItems.isNotEmpty) return true;

    final DataState<CartEntity> state = await _getCartUsecase('');
    if (state is DataSuccess) {
      _cartItems = state.entity?.items ?? <CartItemEntity>[];
    }
    notifyListeners();
    return true;
  }

  Future<DataState<bool>> updateStatus(CartItemEntity item) async {
    try {
      return await _cartItemStatusUpdateUsecase(CartItemModel.fromEntity(item));
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.updateStatus - Catch', error: e);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> removeItem(String id) async {
    try {
      return await _removeFromCartUsecase(id);
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.removeItem - Catch', error: e);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> updateQty(CartItemEntity item, int qty) async {
    try {
      return await _cartUpdateQtyUsecase(
        CartItemUpdateQtyParam(cartItem: item, qty: qty),
      );
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.updateQty - Catch', error: e);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<PostageDetailResponseEntity>> checkout() async {
    try {
      if (_address == null) {
        return DataFailer<PostageDetailResponseEntity>(
            CustomException('No address found'));
      }

      final GetPostageDetailParam params = GetPostageDetailParam(
        buyerAddress: _address!,
        fastDelivery: fastDeliveryProducts,
      );

      final DataState<PostageDetailResponseEntity> result =
          await _getPostageDetailUsecase(params);
      if (result is DataSuccess) {
        _postageResponseEntity = result.entity;
        setCartType(CartType.reviewOrder);
        return result;
      } else {
        return DataFailer<PostageDetailResponseEntity>(result.exception!);
      }
    } catch (e, st) {
      AppLog.error('Failed to fetch postage details',
          name: 'CartProvider.checkout', error: e, stackTrace: st);
      return DataFailer<PostageDetailResponseEntity>(
          CustomException(e.toString()));
    }
  }


  void selectPostageRate(String postId, RateEntity rate) {
    if (postId.isEmpty) return;
    _selectedPostageRates[postId] = rate;
    notifyListeners();
  }

  // MARK:  PAYMENT
  Future<DataState<CheckOutEntity>> payment() async {
    try {
      if ((LocalAuth.currentUser?.address ?? <AddressEntity>[]).isEmpty) {
        return DataFailer<CheckOutEntity>(CustomException('No address found'));
      }
      _address ??= LocalAuth.currentUser?.address
          .where((AddressEntity e) => e.isDefault)
          .first;
      if (_address == null) {
        return DataFailer<CheckOutEntity>(
            CustomException('No default address'));
      }
      return await _getCheckoutUsecase(_address!);
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.checkout - Catch', error: e);
      return DataFailer<CheckOutEntity>(CustomException(e.toString()));
    }
  }

  Future<DataState<String>> getBillingDetails() async {
    try {
      final DataState<String> state = await _payIntentUsecase.call(address!);
      if (state is DataSuccess<String>) {
        final Map<String, dynamic> jsonMap = jsonDecode(state.data ?? '{}');
        _orderBilling = OrderBillingModel.fromMap(jsonMap);
        return state;
      }
      return DataFailer<String>(
          CustomException('Failed to get billing details'));
    } catch (e, st) {
      AppLog.error('Billing details error',
          name: 'CartProvider.getBillingDetails', error: e, stackTrace: st);
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  Future<void> processPayment(BuildContext context) async {
    try {
      final DataState<String> billingDetails = await getBillingDetails();
      final String? clientSecret = billingDetails.entity;
      if (clientSecret == null || clientSecret.isEmpty) {
        AppSnackBar.show('something_wrong'.tr());
        return;
      }

      final PaymentIntent intent =
          await presentStripePaymentSheet(clientSecret, context);

      if (intent.status == PaymentIntentsStatus.Succeeded) {
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            enableDrag: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const PaymentSuccessSheet(),
          );
        }
      } else {
        AppSnackBar.show('payment_not_completed'.tr());
      }
    } catch (e, st) {
      AppLog.error('Payment error',
          name: 'CartProvider.processPayment', error: e, stackTrace: st);
      AppSnackBar.show('something_wrong'.tr());
    }
  }

  Future<PaymentIntent> presentStripePaymentSheet(
      String clientSecret, BuildContext context) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: LocalAuth.currentUser?.userName ?? 'My Store',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return await Stripe.instance.retrievePaymentIntent(clientSecret);
    } catch (e, st) {
      AppLog.error('Stripe error',
          name: 'CartProvider.presentStripePaymentSheet',
          error: e,
          stackTrace: st);
      AppSnackBar.show('payment_failed'.tr());
      rethrow;
    }
  }

  // MARK: ♻️ RESET
  void reset() {
    _orderBilling = null;
    _postageResponseEntity = null;
    _basketPage = CartItemType.cart;
    _address = (LocalAuth.currentUser?.address != null &&
            LocalAuth.currentUser!.address
                .where((AddressEntity e) => e.isDefault)
                .isNotEmpty)
        ? LocalAuth.currentUser!.address
            .where((AddressEntity e) => e.isDefault)
            .first
        : null;
    notifyListeners();
  }
}
