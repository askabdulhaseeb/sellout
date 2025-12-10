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
  Future<DataState<List<PromoEntity>>> getPromoByid(String id);
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  @override
  Future<DataState<bool>> createPromo(CreatePromoParams param) async {
    try {
      final DataState<String> result = await ApiCall<String>().callFormData(
        endpoint: '/promo/create',
        requestType: ApiRequestType.post,
        fileMap: param.getAttachmentsMap(),
        fieldsMap: param.toMap(),
        isConnectType: false,
        isAuth: true,
      );
      if (result is DataSuccess<String>) {
        AppLog.info(
          'Promo created successfully: ${result.data}',
          name: 'PromoRemoteDataSourceImpl.createPromo - if',
        );
        return DataSuccess<bool>(result.data!, true);
      } else if (result is DataFailer<String>) {
        AppLog.error(
          result.exception?.message ?? 'Unknown error during promo creation',
          name: 'PromoRemoteDataSourceImpl.createPromo - else if',
          error: result.exception?.reason ?? 'something_wrong',
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('Something went wrong'),
        );
      } else {
        AppLog.error(
          'Unexpected state in createPromo',
          name: 'PromoRemoteDataSourceImpl.createPromo - else',
        );
        return DataFailer<bool>(CustomException('Unexpected API state'));
      }
    } catch (e, stc) {
      AppLog.error(
        'Exception during createPromo: $e',
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
      final DataState<List<PromoEntity>> result =
          await ApiCall<List<PromoEntity>>().call(
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
        final List<PromoEntity> promoModels = listOfPromoMap
            .map((Map<String, dynamic> map) => PromoModel.fromMap(map))
            .toList();
        // 🔽 Save all promos to Hive
        await LocalPromo().saveAllPromo(promoModels);
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

  @override
  Future<DataState<List<PromoEntity>>> getPromoByid(String uid) async {
    String endpoint = '/promo/query?user_id=$uid';

    try {
      final DataState<List<PromoEntity>> result =
          await ApiCall<List<PromoEntity>>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );

      if (result is DataSuccess) {
        // Decode the full response body
        Map<String, dynamic> mapdata = jsonDecode(result.data!);
        List<Map<String, dynamic>> listOfPromoMap =
            List<Map<String, dynamic>>.from(mapdata['data'] ?? <dynamic>[]);

        // Convert map to PromoEntity list
        final List<PromoEntity> promoModels = listOfPromoMap
            .map((Map<String, dynamic> map) => PromoModel.fromMap(map))
            .toList();

        // ✅ Save to Hive using LocalPromo
        await LocalPromo().saveAllPromo(promoModels);

        return DataSuccess<List<PromoEntity>>(result.data ?? '', promoModels);
      } else {
        AppLog.error(
          result.exception?.message ??
              'PromoRemoteDataSourceImpl.getPromoByid - else',
          name: 'PromoRemoteDataSourceImpl.getPromoByid - failed',
          error: result.exception,
        );
        return DataFailer<List<PromoEntity>>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'PromoRemoteDataSourceImpl.getPromoByid - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<List<PromoEntity>>(CustomException(e.toString()));
    }
  }
}
