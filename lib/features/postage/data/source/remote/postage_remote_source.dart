import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../../../personal/basket/domain/param/submit_shipping_param.dart';
import '../../../../personal/order/data/models/shipping_detail_model.dart';
import '../../../../personal/order/data/source/local/local_orders.dart';
import '../../../../personal/order/domain/entities/order_entity.dart';
import '../../../domain/params/add_label_params.dart';
import '../../../domain/params/add_order_label_params.dart';
import '../../../domain/params/get_order_postage_detail_params.dart';
import '../../models/postage_detail_repsonse_model.dart';

abstract interface class PostageRemoteApi {
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
    GetPostageDetailParam param,
  );
  Future<DataState<AddShippingResponseModel>> addShipping(
    SubmitShippingParam param,
  );
  Future<DataState<PostageDetailResponseModel>> getOrderPostageDetail(
    GetOrderPostageDetailParam param,
  );
  Future<DataState<bool>> buylabel(BuyLabelParams param);

  /// Adds shipping to an order
  Future<DataState<bool>> addOrderShipping(AddOrderShippingParams params);
}

class PostageRemoteApiImpl implements PostageRemoteApi {
  @override
  Future<DataState<bool>> addOrderShipping(
    AddOrderShippingParams params,
  ) async {
    try {
      const String endpoint = '/orders/shipping/add';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: jsonEncode(params.toJson()),
      );
      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        AppLog.info('addOrderShipping response: $raw');
        // Parse response JSON
        final dynamic parsed = jsonDecode(raw);
        final String? orderId = parsed['order_id'];
        final dynamic shippingDetailJson = parsed['shipping_detail'];
        if (orderId != null && shippingDetailJson != null) {
          // Get the existing order from LocalOrders
          final OrderEntity? order = LocalOrders().get(orderId);
          if (order != null) {
            // Update the order with new shipping details
            final OrderEntity updatedOrder = order.copyWith(
              shippingDetail: ShippingDetailModel.fromJson(shippingDetailJson),
            );
            await LocalOrders().save(orderId, updatedOrder);
          }
        }
        return DataSuccess<bool>(raw, true);
      } else {
        AppLog.error(
          params.toJson().toString(),
          name: 'PostageRemoteApiImpl.addOrderShipping - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('Failed to add order shipping'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'PostageRemoteApiImpl.addOrderShipping - Catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
    GetPostageDetailParam param,
  ) async {
    try {
      const String endpoint = '/cart/get/postage';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: param.toJson(),
      );
      if (result is DataSuccess<String>) {
        AppLog.info(
          param.toJson().toString(),
          name: 'PostageRemoteApiImpl.getPostageDetails - If',
        );
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty postage response',
            name: 'PostageRemoteApiImpl.getPostageDetails - Empty',
          );
          return DataFailer<PostageDetailResponseModel>(
            CustomException('Empty postage details response'),
          );
        }
        final Map<String, dynamic> json =
            (jsonDecode(raw) is Map<String, dynamic>)
            ? jsonDecode(raw) as Map<String, dynamic>
            : <String, dynamic>{};

        final PostageDetailResponseModel model =
            PostageDetailResponseModel.fromJson(json);
        AppLog.info(model.toJson().toString());
        AppLog.info(
          'Fetched postage details',
          name: 'PostageRemoteApiImpl.getPostageDetails - Success',
        );
        return DataSuccess<PostageDetailResponseModel>(raw, model);
      } else {
        AppLog.error(
          param.toJson(),
          name: 'PostageRemoteApiImpl.getPostageDetails - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<PostageDetailResponseModel>(
          CustomException('Failed to get postage details'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        '',
        name: 'PostageRemoteApiImpl.getPostageDetails - Catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<PostageDetailResponseModel>(
        CustomException(e.toString()),
      );
    }
  }

  @override
  Future<DataState<AddShippingResponseModel>> addShipping(
    SubmitShippingParam param,
  ) async {
    try {
      const String endpoint = '/cart/add/shipping';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: jsonEncode(param.toJson()),
      );
      if (result is DataSuccess<String>) {
        AppLog.info(
          jsonEncode(result.data),
          name: 'PostageRemoteApiImpl.addShipping - If',
        );
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty addShipping response',
            name: 'PostageRemoteApiImpl.addShipping - Empty',
          );
          return DataFailer<AddShippingResponseModel>(
            CustomException('Empty response from add shipping'),
          );
        }

        try {
          final dynamic decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            final AddShippingResponseModel responseModel =
                AddShippingResponseModel.fromJson(decoded);
            final String logMessage = responseModel.message.isNotEmpty
                ? responseModel.message
                : 'Selected shipping added';
            AppLog.info(
              logMessage,
              name: 'PostageRemoteApiImpl.addShipping - Success',
            );
            return DataSuccess<AddShippingResponseModel>(raw, responseModel);
          }
          AppLog.error(
            'Unexpected addShipping response structure',
            name: 'PostageRemoteApiImpl.addShipping - InvalidStructure',
          );
        } catch (e) {
          AppLog.error(
            'Failed to parse addShipping response: $e',
            name: 'PostageRemoteApiImpl.addShipping - ParseError',
            error: e,
          );
        }
        return DataFailer<AddShippingResponseModel>(
          CustomException('Invalid add shipping response structure'),
        );
      } else {
        AppLog.error(
          jsonEncode(param.toJson()),
          name: 'PostageRemoteApiImpl.addShipping - Else',
          level: result.exception?.code ?? 0,
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<AddShippingResponseModel>(
          result.exception ?? CustomException('Failed to add shipping'),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostageRemoteApiImpl.addShipping - Catch',
        error: e,
      );
      return DataFailer<AddShippingResponseModel>(
        CustomException(e.toString()),
      );
    }
  }

  @override
  Future<DataState<PostageDetailResponseModel>> getOrderPostageDetail(
    GetOrderPostageDetailParam param,
  ) async {
    try {
      const String endpoint = '/orders/shipping/rates';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: jsonEncode(param.toJson()),
      );
      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty getOrderPostageDetail response',
            name: 'PostageRemoteApiImpl.getOrderPostageDetail - Empty',
          );
          return DataFailer<PostageDetailResponseModel>(
            CustomException('Empty getOrderPostageDetail response'),
          );
        }
        final Map<String, dynamic> json =
            (jsonDecode(raw) is Map<String, dynamic>)
            ? jsonDecode(raw) as Map<String, dynamic>
            : <String, dynamic>{};

        final PostageDetailResponseModel model =
            PostageDetailResponseModel.fromJson(json);
        AppLog.info(model.toJson().toString());
        AppLog.info(
          'Fetched order postage details',
          name: 'PostageRemoteApiImpl.getOrderPostageDetail - Success',
        );
        return DataSuccess<PostageDetailResponseModel>(raw, model);
      } else {
        AppLog.error(
          param.toJson().toString(),
          name: 'PostageRemoteApiImpl.getOrderPostageDetail - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<PostageDetailResponseModel>(
          CustomException('Failed to get order postage details'),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostageRemoteApiImpl.getOrderPostageDetail - Catch',
        error: e,
      );
      return DataFailer<PostageDetailResponseModel>(
        CustomException(e.toString()),
      );
    }
  }

  @override
  Future<DataState<bool>> buylabel(BuyLabelParams param) async {
    try {
      const String endpoint = '/orders/buy/label';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: jsonEncode(param.toJson()),
      );
      debugPrint('Buy label result: ${param.toJson()}');
      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        AppLog.info(
          param.toJson().toString(),
          name: 'PostageRemoteApiImpl.buylabel - If',
        );

        if (raw.isNotEmpty) {
          try {
            final dynamic decoded = jsonDecode(raw);
            final Map<String, dynamic> json = (decoded is Map<String, dynamic>)
                ? decoded
                : <String, dynamic>{};

            // Try to obtain shipping detail and order id from response
            final dynamic shippingDetailJson =
                json['shipping_detail'] ?? json['shippingDetails'];
            String? orderId;
            if (json.containsKey('order_id')) {
              orderId = json['order_id']?.toString();
            } else {
              final dynamic requestJson = param.toJson();
              if (requestJson is Map<String, dynamic>) {
                orderId =
                    requestJson['order_id']?.toString() ??
                    requestJson['orderId']?.toString();
              }
            }

            if (orderId != null && shippingDetailJson != null) {
              final OrderEntity? order = LocalOrders().get(orderId);
              if (order != null) {
                final OrderEntity updatedOrder = order.copyWith(
                  shippingDetail: ShippingDetailModel.fromJson(
                    shippingDetailJson,
                  ),
                  orderStatus: StatusType.readyToShip,
                );
                await LocalOrders().save(orderId, updatedOrder);
                final bool exists = LocalOrders().containsKey(orderId);
                final OrderEntity? after = LocalOrders().get(orderId);
                AppLog.info(
                  'Local order $orderId updated with shipping detail. exists=$exists, after!=null=${after != null}',
                  name: 'PostageRemoteApiImpl.buylabel - LocalUpdate',
                );
              }
            }
          } catch (e, stc) {
            AppLog.error(
              'Failed to parse buylabel response: $e',
              name: 'PostageRemoteApiImpl.buylabel - ParseError',
              error: e,
              stackTrace: stc,
            );
          }
        }

        AppLog.info(
          'Fetched postage details ${raw.toString()}',
          name: 'PostageRemoteApiImpl.buylabel - Success',
        );
        return DataSuccess<bool>(raw, true);
      } else {
        AppLog.error(
          param.toJson().toString(),
          name: 'PostageRemoteApiImpl.buylabel - Else',
          error:
              result.exception?.reason ??
              result.exception?.message ??
              result.exception?.code ??
              'something_wrong'.tr(),
        );
        return DataFailer<bool>(
          CustomException('Failed to get postage details'),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostageRemoteApiImpl.buylabel - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
