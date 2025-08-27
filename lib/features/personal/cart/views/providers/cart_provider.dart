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
import '../../domain/entities/cart/cart_entity.dart';
import '../../domain/entities/checkout/check_out_entity.dart';
import '../../domain/param/cart_item_update_qty_param.dart';
import '../../domain/usecase/cart/cart_item_status_update_usecase.dart';
import '../../domain/usecase/cart/cart_update_qty_usecase.dart';
import '../../domain/usecase/cart/get_cart_usecase.dart';
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
  );
  final GetCartUsecase _getCartUsecase;
  final CartItemStatusUpdateUsecase _cartItemStatusUpdateUsecase;
  final RemoveFromCartUsecase _removeFromCartUsecase;
  final CartUpdateQtyUsecase _cartUpdateQtyUsecase;
  final GetCheckoutUsecase _getCheckoutUsecase;
  final PayIntentUsecase _payIntentUsecase;
  List<CartItemEntity> _cartItems = <CartItemEntity>[];
//
  int _page = 1;
  int get page => _page;
//
  OrderBillingModel? _orderBilling;
  OrderBillingModel? get orderBilling => _orderBilling;
//
  CheckOutEntity? _checkoutEntity;
  CheckOutEntity? get checkoutEntity => _checkoutEntity;
//
  CartItemType _basketPage = CartItemType.cart;
  CartItemType get basketPage => _basketPage;
//
  // bool _isLoading = false;
  // bool get isLoading => _isLoading;
  // void setloading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

//
  AddressEntity? _address = (LocalAuth.currentUser?.address != null &&
          LocalAuth.currentUser!.address
              .where((AddressEntity element) => element.isDefault)
              .isNotEmpty)
      ? LocalAuth.currentUser!.address
          .where((AddressEntity element) => element.isDefault)
          .first
      : null;
  AddressEntity? get address => _address;

  set address(AddressEntity? value) {
    _address = value;
    notifyListeners();
  }

  set basketPage(CartItemType value) {
    _basketPage = value;
    notifyListeners();
  }

  List<CartItemEntity> get cartItems => _cartItems;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  Future<bool> getCart() async {
    if (_cartItems.isNotEmpty) {
      return true;
    }
    final DataState<CartEntity> satte = await _getCartUsecase('');
    if (satte is DataSuccess) {
      _cartItems = satte.entity?.items ?? <CartItemEntity>[];
    }
    notifyListeners();
    return true;
  }

  Future<DataState<CheckOutEntity>> checkout() async {
    try {
      if ((LocalAuth.currentUser?.address ?? <AddressEntity>[]).isEmpty) {
        return DataFailer<CheckOutEntity>(CustomException('message'));
      }
      _address ??= LocalAuth.currentUser?.address
          .where((AddressEntity element) => element.isDefault)
          .first;
      if (_address == null) {
        return DataFailer<CheckOutEntity>(CustomException('message'));
      }
      final DataState<CheckOutEntity> state =
          await _getCheckoutUsecase(_address!);
      return state;
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.checkout - Catch',
        error: e,
      );
      return DataFailer<CheckOutEntity>(CustomException(e.toString()));
    } finally {}
  }

  Future<DataState<bool>> updateStatus(CartItemEntity value) async {
    try {
      return await _cartItemStatusUpdateUsecase(
          CartItemModel.fromEntity(value));
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.updateStatus - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    } finally {}
  }

  Future<DataState<bool>> removeItem(String id) async {
    try {
      return await _removeFromCartUsecase(id);
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.removeItem - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    } finally {}
  }

  Future<DataState<bool>> updateQty(CartItemEntity cartItem, int qty) async {
    try {
      return await _cartUpdateQtyUsecase(
        CartItemUpdateQtyParam(
          cartItem: cartItem,
          qty: qty,
        ),
      );
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.updateQty - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<void> processPayment(BuildContext context) async {
    try {
      final DataState<String> billingDetails = await getBillingDetails();

      if (billingDetails is DataFailer<String>) {
        // Show a snackbar or dialog with the failure reason
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
        return;
      }

      final String? clientSecret = billingDetails.entity;
      if (clientSecret == null || clientSecret.isEmpty) {
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
        return;
      }

      final PaymentIntent intent =
          await presentStripePaymentSheet(clientSecret, context);

      // Optional: Check status of payment intent
      if (intent.status == PaymentIntentsStatus.Succeeded) {
        if (context.mounted) {
          showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: context,
            enableDrag: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const PaymentSuccessSheet(),
          );
        }
      } else {
        AppSnackBar.showSnackBar(context, 'payment_not_completed'.tr());
      }
    } catch (e, st) {
      AppLog.error('Payment processing error',
          name: 'CartProvider.processPayment', error: e, stackTrace: st);
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
    }
  }

  Future<DataState<String>> getBillingDetails() async {
    try {
      final DataState<String> state = await _payIntentUsecase.call(address!);

      if (state is DataSuccess<String>) {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(state.data ?? '{}');
          _orderBilling = OrderBillingModel.fromMap(jsonMap);
        } catch (decodeErr) {
          return DataFailer<String>(CustomException('Invalid billing JSON'));
        }
      }
      return state;
    } catch (e, st) {
      AppLog.error('Getting billing detail error',
          name: 'CartProvider.getBillingDetails', error: e, stackTrace: st);
      debugPrint('Error in getBillingDetails: $e\n$st');
      return DataFailer<String>(CustomException(e.toString()));
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
    } on StripeException catch (e, st) {
      AppLog.error('Stripe error',
          name: 'CartProvider.presentStripePaymentSheet',
          error: e,
          stackTrace: st);
      AppSnackBar.showSnackBar(context, 'payment_failed'.tr());
      rethrow; // let processPayment decide what to do
    } catch (e, st) {
      AppLog.error('Unknown payment error',
          name: 'CartProvider.presentStripePaymentSheet',
          error: e,
          stackTrace: st);
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      rethrow;
    }
  }

  void reset() {
    _page = 1;
    _orderBilling = null;
    _checkoutEntity = null;
    _basketPage = CartItemType.cart;
    _address = (LocalAuth.currentUser?.address != null &&
            LocalAuth.currentUser!.address
                .where((AddressEntity element) => element.isDefault)
                .isNotEmpty)
        ? LocalAuth.currentUser!.address
            .where((AddressEntity element) => element.isDefault)
            .first
        : null;
    notifyListeners();
  }
}
