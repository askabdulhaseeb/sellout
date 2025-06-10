import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../domain/entities/promo_entity.dart';
import '../../../domain/params/create_promo_params.dart';
import '../../model/promo_model.dart';
import '../local/local_promo.dart';

abstract class PromoRemoteDataSource {
 Future<DataState<bool>> createPromo(CreatePromoParams promo);
 Future<DataState<List<PromoEntity>>> getPromoOfFollower();
}


class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  @override
  Future<DataState<bool>> createPromo(CreatePromoParams param) async {
    String endpoint ='/promo/create';

    try {
      final DataState<bool> result = await ApiCall<bool>().callFormData(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        attachments:param.attachments,
        fieldsMap:param.toMap(),
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
  @override
Future<DataState<List<PromoEntity>>> getPromoOfFollower() async {
  String endpoint = '/promo/followers/get';
  final List<String> supporterIds = LocalAuth.currentUser?.supporters
          .map((SupporterDetailEntity supporter) => supporter.userID)
          .toList() ??
      <String>[];

  debugPrint(jsonEncode(supporterIds));

  try {
    final DataState<List<PromoEntity>> result = await ApiCall<List<PromoEntity>>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
      isAuth: true,
      body: json.encode(<String, List<String>>{
        'follower_ids': supporterIds,
      }),
    );

    if (result is DataSuccess) {
      debugPrint(result.data);
      Map<String, dynamic> mapdata = jsonDecode(result.data!);
      List<Map<String, dynamic>> listOfPromoMap =
          List<Map<String, dynamic>>.from(mapdata['data'] ?? <dynamic>[]);
      // 🔽 Convert all maps to PromoModel
      final List<PromoEntity> promoModels =
          listOfPromoMap.map((Map<String, dynamic> map) => PromoModel.fromMap(map)).toList();
      // 🔽 Save all promos to Hive
      await LocalPromo().saveAll(promoModels);
      return DataSuccess<List<PromoEntity>>(result.data ?? '', promoModels);
    } else {
      AppLog.error(
        result.exception?.message ??
            'PromoRemoteDataSourceImpl.getPromoOfFollower - else',
        name: 'PromoRemoteDataSourceImpl.getPromoOfFollower - failed',
        error: result.exception,
      );
      return DataFailer<List<PromoEntity>>(
        result.exception ?? CustomException('something_wrong'.tr()),
      );
    }
  } catch (e, stc) {
    AppLog.error(
      e.toString(),
      name: 'PromoRemoteDataSourceImpl.getPromoOfFollower - catch',
      error: e,
      stackTrace: stc,
    );
    return DataFailer<List<PromoEntity>>(CustomException(e.toString()));
  }
}


}
