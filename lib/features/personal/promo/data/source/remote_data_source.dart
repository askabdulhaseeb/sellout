import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/params/create_promo_params.dart';

abstract class PromoRemoteDataSource {
 Future<DataState<bool>> createPromo(CreatePromoParams promo);
}


class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  @override
  Future<DataState<bool>> createPromo(CreatePromoParams param) async {
    String endpoint ='/promo/create';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );

      if (result is DataSuccess) {
        debugPrint(result.data);
        debugPrint(param.toString());
        return DataSuccess<bool>(result.data!, true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'PromoRemoteDataSourceImpl.createPromo - else',
          name: 'PromoRemoteDataSourceImpl.createPromo - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      debugPrint(param.toString());

      AppLog.error(
        e.toString(),
        name: 'PromoRemoteDataSourceImpl.createPromo - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

}
