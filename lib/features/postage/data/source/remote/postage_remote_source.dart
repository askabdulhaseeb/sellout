import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../../../personal/basket/domain/param/submit_shipping_param.dart';
import '../../models/postage_detail_repsonse_model.dart';

abstract interface class PostageRemoteApi {
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
      GetPostageDetailParam param);
  Future<DataState<AddShippingResponseModel>> addShipping(
      SubmitShippingParam param);
}

class PostageRemoteApiImpl implements PostageRemoteApi {
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
            name: 'PostageRemoteApiImpl.getPostageDetails - Success');
        return DataSuccess<PostageDetailResponseModel>(raw, model);
      } else {
        AppLog.error(
          param.toJson(),
          name: 'PostageRemoteApiImpl.getPostageDetails - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<PostageDetailResponseModel>(
            CustomException('Failed to get postage details'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostageRemoteApiImpl.getPostageDetails - Catch',
        error: e,
      );
      return DataFailer<PostageDetailResponseModel>(
          CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<AddShippingResponseModel>> addShipping(
      SubmitShippingParam param) async {
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
            result.exception ?? CustomException('Failed to add shipping'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostageRemoteApiImpl.addShipping - Catch',
        error: e,
      );
      return DataFailer<AddShippingResponseModel>(
          CustomException(e.toString()));
    }
  }
}
