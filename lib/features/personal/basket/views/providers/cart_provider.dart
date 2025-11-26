import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';
import '../../data/models/cart/add_shipping_response_model.dart';
import '../../data/models/cart/cart_model.dart';
import '../../data/sources/local/local_cart.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../../domain/entities/cart/added_shipping_response_entity.dart';
import '../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../domain/entities/checkout/check_out_entity.dart';
import '../../domain/entities/checkout/payment_intent_entity.dart';
import '../../domain/enums/cart_type.dart';
import '../../domain/enums/shopping_basket_type.dart';
import '../../domain/param/cart_item_update_qty_param.dart';
import '../../domain/param/get_postage_detail_params.dart';
import '../../domain/param/submit_shipping_param.dart';
import '../../domain/usecase/cart/add_shipping_usecase.dart';
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
    this._addShippingUsecase,
  );
  // Track if postage rates are loading
  bool _loadingPostage = false;

  bool get loadingPostage => _loadingPostage;
  // MARK: 🧱  Dependencies
  final GetCartUsecase _getCartUsecase;
  final CartItemStatusUpdateUsecase _cartItemStatusUpdateUsecase;
  final RemoveFromCartUsecase _removeFromCartUsecase;
  final CartUpdateQtyUsecase _cartUpdateQtyUsecase;
  final GetCheckoutUsecase _getCheckoutUsecase;
  final PayIntentUsecase _payIntentUsecase;
  final GetPostageDetailUsecase _getPostageDetailUsecase;
  final AddShippingUsecase _addShippingUsecase;

  // MARK: ⚙️ State Variables
  ShoppingBasketPageType _shoppingBasketType = ShoppingBasketPageType.basket;
  CartType _cartType = CartType.shoppingBasket;
  CartItemStatusType _basketItemStatus = CartItemStatusType.cart;

  List<CartItemEntity> _cartItems = <CartItemEntity>[];
  bool _isFetchingCart = false;
  final List<String> _fastDeliveryProducts = <String>[];
  PaymentIntentEntity? _orderBilling;
  PostageDetailResponseEntity? _postageResponseEntity;
  AddedShippingResponseEntity? _addShippingResponse;
  // selected postage rate per postID
  final Map<String, RateEntity> _selectedPostageRates = <String, RateEntity>{};
  // Map to store selected rate objectId for each postId
  final Map<String, String> _selectedRateObjectIds = <String, String>{};

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
  PaymentIntentEntity? get orderBilling => _orderBilling;
  PostageDetailResponseEntity? get postageResponseEntity =>
      _postageResponseEntity;
  AddedShippingResponseEntity? get addShippingResponse => _addShippingResponse;
  Map<String, RateEntity> get selectedPostageRates => _selectedPostageRates;
  CartItemStatusType get basketItemStatus => _basketItemStatus;
  AddressEntity? get address => _address;

  /// Returns true if any cart item requires removal because delivery is unavailable.
  /// Criteria: originalDeliveryType is paid or fast delivery AND no rates found.
  bool get hasItemsRequiringRemoval {
    if (_postageResponseEntity == null) return false;
    for (final PostageItemDetailEntity detail
        in _postageResponseEntity!.detail.values) {
      final DeliveryType deliveryType =
          DeliveryType.fromJson(detail.originalDeliveryType);
      final bool isDeliveryNeeded = deliveryType == DeliveryType.paid ||
          deliveryType == DeliveryType.fastDelivery;
      if (!isDeliveryNeeded) continue;
      final bool hasRates = detail.shippingDetails
          .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
          .isNotEmpty;
      if (!hasRates) return true;
    }
    return false;
  }

  List<String> get itemsRequiringRemovalPostIds {
    if (_postageResponseEntity == null) return <String>[];
    final List<String> ids = <String>[];
    _postageResponseEntity!.detail
        .forEach((String postId, PostageItemDetailEntity detail) {
      final DeliveryType deliveryType =
          DeliveryType.fromJson(detail.originalDeliveryType);
      final bool isDeliveryNeeded = deliveryType == DeliveryType.paid ||
          deliveryType == DeliveryType.fastDelivery;
      if (!isDeliveryNeeded) return;
      final bool hasRates = detail.shippingDetails
          .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
          .isNotEmpty;
      if (!hasRates) ids.add(postId);
    });
    return ids;
  }

  // MARK: ✏️ Setters
  void setCartType(CartType type) {
    _cartType = type;
    if (_cartType == CartType.shoppingBasket ||
        _cartType == CartType.checkoutOrder) {
      _addShippingResponse = null;
    }
    notifyListeners();
  }

  void setBasketPageType(ShoppingBasketPageType type) {
    _shoppingBasketType = type;
    notifyListeners();
  }

  void setPostageLoading(bool val) {
    _loadingPostage = val;
    notifyListeners();
  }

  void setAddress(AddressEntity? value) {
    _address = value;
    _postageResponseEntity = null;
    _selectedPostageRates.clear();
    _selectedRateObjectIds.clear();
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

  Future<bool> getCart({bool forceRefresh = false}) async {
    if (_isFetchingCart) return _cartItems.isNotEmpty;

    if (!forceRefresh && _cartItems.isNotEmpty) {
      return true;
    }

    _isFetchingCart = true;

    try {
      final DataState<CartEntity> state = await _getCartUsecase('');
      if (state is DataSuccess) {
        _cartItems = state.entity?.items ?? <CartItemEntity>[];
        notifyListeners();
        return true;
      } else {
        AppLog.error('Failed to get cart: ${state.exception?.message}',
            name: 'CartProvider.getCart');
        return false;
      }
    } catch (e, st) {
      AppLog.error('Error getting cart',
          name: 'CartProvider.getCart', error: e, stackTrace: st);
      return false;
    } finally {
      _isFetchingCart = false;
    }
  }

  Future<DataState<bool>> updateStatus(CartItemEntity item) async {
    try {
      // Validate item before updating
      if (item.cartItemID.isEmpty) {
        return DataFailer<bool>(CustomException('Invalid cart item ID'));
      }

      final DataState<bool> result =
          await _cartItemStatusUpdateUsecase(CartItemModel.fromEntity(item));

      if (result is DataSuccess) {
        // Update local state if successful
        final int index = _cartItems
            .indexWhere((CartItemEntity e) => e.cartItemID == item.cartItemID);
        if (index >= 0) {
          _cartItems[index] = item;
          notifyListeners();
        }
      }

      return result;
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.updateStatus - Catch', error: e);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> removeItem(String id) async {
    try {
      // Validate ID
      if (id.isEmpty) {
        return DataFailer<bool>(CustomException('Invalid item ID'));
      }

      final DataState<bool> result = await _removeFromCartUsecase(id);

      if (result is DataSuccess) {
        // Update local state if successful
        _cartItems.removeWhere((CartItemEntity e) => e.cartItemID == id);
        notifyListeners();
      }

      return result;
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.removeItem - Catch', error: e);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> updateQty(CartItemEntity item, int qty) async {
    try {
      // Validate parameters
      if (item.cartItemID.isEmpty) {
        return DataFailer<bool>(CustomException('Invalid cart item'));
      }

      if (qty <= 0) {
        return DataFailer<bool>(
            CustomException('Quantity must be greater than 0'));
      }

      final DataState<bool> result = await _cartUpdateQtyUsecase(
        CartItemUpdateQtyParam(cartItem: item, qty: qty),
      );

      if (result is DataSuccess) {
        // Update local state if successful
        final int index = _cartItems
            .indexWhere((CartItemEntity e) => e.cartItemID == item.cartItemID);
        if (index >= 0) {
          _cartItems[index].quantity = qty;
          notifyListeners();
        }
      }

      return result;
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'CartProvider.updateQty - Catch', error: e);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  // MARK: 📦 GET Postage Rates

  Future<DataState<PostageDetailResponseEntity>> getRates() async {
    try {
      setPostageLoading(true);
      if (_address == null) {
        setPostageLoading(false);
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
        // Automatically select first rate for each post and store shipmentId
        if (_postageResponseEntity != null) {
          _postageResponseEntity!.detail.forEach(
            (String postId, PostageItemDetailEntity detail) {
              // Only auto-select if not already selected
              if (!_selectedPostageRates.containsKey(postId)) {
                final List<RateEntity> rates = detail.shippingDetails
                    .expand((PostageDetailShippingDetailEntity sd) =>
                        sd.ratesBuffered)
                    .toList();
                if (rates.isNotEmpty) {
                  final RateEntity firstRate = rates.first;
                  _selectedPostageRates[postId] = firstRate;
                  _selectedRateObjectIds[postId] = firstRate.objectId;
                }
              }
            },
          );
        }
        setPostageLoading(false);

        return result;
      } else {
        setPostageLoading(false);
        return DataFailer<PostageDetailResponseEntity>(result.exception!);
      }
    } catch (e, st) {
      setPostageLoading(false);
      AppLog.error('Failed to fetch postage details',
          name: 'CartProvider.checkout', error: e, stackTrace: st);
      return DataFailer<PostageDetailResponseEntity>(
          CustomException(e.toString()));
    }
  }

  void selectPostageRate(String postId, RateEntity rate) {
    if (postId.isEmpty) return;
    _selectedPostageRates[postId] = rate;
    _selectedRateObjectIds[postId] = rate.objectId;

    notifyListeners();
  }

  /// Build a checkout payload map. This includes buyer address, cart items
  /// (only items currently in cart), selected postage rates per post, and
  /// the shipping payload derived from selected rates.
  Map<String, dynamic> buildCheckoutMap() {
    if (_address == null) return <String, dynamic>{};

    final Map<String, dynamic> buyerAddress =
        AddressModel.fromEntity(_address!).toJson();

    final List<Map<String, dynamic>> items = _cartItems
        .where((CartItemEntity it) => it.inCart)
        .map((CartItemEntity it) => <String, dynamic>{
              'cart_item_id': it.cartItemID,
              'post_id': it.postID,
              'quantity': it.quantity,
            })
        .toList();

    final Map<String, dynamic> postage = <String, dynamic>{};
    _selectedPostageRates.forEach((String postId, RateEntity rate) {
      postage[postId] = <String, dynamic>{
        'provider': rate.provider,
        'service_level': <String, String>{
          'name': rate.serviceLevel.name,
          'token': rate.serviceLevel.token,
        },
        'amount':
            rate.amountBuffered.isNotEmpty ? rate.amountBuffered : rate.amount,
        'provider_image75': rate.providerImage75,
      };
    });

    final List<Map<String, dynamic>> shipping = buildShippingList()
        .map((ShippingItemParam item) => item.toJson())
        .toList();

    return <String, dynamic>{
      'buyer_address': buyerAddress,
      'items': items,
      'postage': postage,
      if (shipping.isNotEmpty) 'shipping': shipping,
    };
  }

  /// JSON-encoded checkout payload.
  String buildCheckoutJson() => json.encode(buildCheckoutMap());

  List<ShippingItemParam> buildShippingList() {
    final List<ShippingItemParam> shippingList = <ShippingItemParam>[];

    // Map each cart item to its selected shipping shipment ID
    for (final CartItemEntity item in _cartItems) {
      if (!item.inCart) continue;

      final String? objectId = _selectedRateObjectIds[item.postID];
      if (objectId == null || objectId.isEmpty) {
        // Skip items without selected shipping (e.g., collection/free delivery)
        continue;
      }

      shippingList.add(ShippingItemParam(
        cartItemId: item.cartItemID,
        objectId: objectId,
      ));
    }

    return shippingList;
  }

  /// Build shipping payload using SubmitShippingParam.
  SubmitShippingParam buildShippingPayload() {
    return SubmitShippingParam(shipping: buildShippingList());
  }

  //MARK: Add Shippments
  Future<DataState<AddShippingResponseModel>> submitShipping() async {
    try {
      final List<ShippingItemParam> shippingList = buildShippingList();
      if (shippingList.isEmpty) {
        AppLog.error('No shipping items to submit',
            name: 'CartProvider.submitShipping');
        return DataFailer<AddShippingResponseModel>(
            CustomException('No shipping items to submit'));
      }

      final SubmitShippingParam payload = buildShippingPayload();
      final DataState<AddShippingResponseModel> result =
          await _addShippingUsecase(payload);

      if (result is DataSuccess<AddShippingResponseModel>) {
        _addShippingResponse = result.entity;
        AppLog.info('Shipping submitted successfully',
            name: 'CartProvider.submitShipping');
        return result;
      } else {
        AppLog.error('Failed to submit shipping',
            name: 'CartProvider.submitShipping',
            error: result.exception?.reason);
        return result;
      }
    } catch (e, st) {
      AppLog.error(e.toString(),
          name: 'CartProvider.submitShipping - Catch',
          error: e,
          stackTrace: st);
      return DataFailer<AddShippingResponseModel>(
          CustomException(e.toString()));
    }
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

  Future<DataState<PaymentIntentEntity>> getBillingDetails() async {
    try {
      final DataState<PaymentIntentEntity> state =
          await _payIntentUsecase.call('');
      if (state is DataSuccess<PaymentIntentEntity>) {
        _orderBilling = state.entity;
        return state;
      }
      return DataFailer<PaymentIntentEntity>(
          CustomException('Failed to get billing details'));
    } catch (e, st) {
      AppLog.error('Billing details error',
          name: 'CartProvider.getBillingDetails', error: e, stackTrace: st);
      return DataFailer<PaymentIntentEntity>(CustomException(e.toString()));
    }
  }

  Future<void> processPayment(BuildContext context) async {
    try {
      final DataState<PaymentIntentEntity> billingDetails =
          await getBillingDetails();
      final String? clientSecret = billingDetails.entity?.clientSecret;
      if (clientSecret == null || clientSecret.isEmpty) {
        AppSnackBar.show('something_wrong'.tr());
        return;
      }

      final PaymentIntent intent =
          await presentStripePaymentSheet(clientSecret, context);

      if (intent.status == PaymentIntentsStatus.Succeeded) {
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

  void clearRatesAndCheckout() {
    _postageResponseEntity = null;
    _selectedPostageRates.clear();
    _selectedRateObjectIds.clear();
    notifyListeners();
  }

  // MARK: ♻️ RESET
  void reset() {
    _orderBilling = null;
    _postageResponseEntity = null;
    _addShippingResponse = null;
    _selectedPostageRates.clear();
    _selectedRateObjectIds.clear();
    _fastDeliveryProducts.clear();
    _basketItemStatus = CartItemStatusType.cart;
    _cartType = CartType.shoppingBasket;
    _shoppingBasketType = ShoppingBasketPageType.basket;
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
