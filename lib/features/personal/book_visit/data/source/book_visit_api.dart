import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../post/data/models/visit/visiting_model.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/params/book_visit_params.dart';
import '../../view/params/update_visit_params.dart';

abstract interface class BookVisitApi {
  Future<DataState<VisitingEntity>> bookVisit(BookVisitParams params);
  Future<DataState<VisitingEntity>> cancelVisit(UpdateVisitParams params);
  Future<DataState<VisitingEntity>> updateVisit(UpdateVisitParams params);
}

class BookVisitApiImpl implements BookVisitApi {
  @override
  Future<DataState<VisitingEntity>> bookVisit(BookVisitParams params) async {
    const String endpoint = '/visit/create';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
      );

      if (result is DataSuccess<String>) {
        debugPrint(result.data);

        final Map<String, dynamic> decodedData =
            json.decode(result.data ?? '{}');
        final VisitingEntity? visitingItem = decodedData.containsKey('items')
            ? VisitingModel.fromJson(decodedData['items'])
            : null;

        final String chatId = decodedData['chat_id'] ?? '';
        return DataSuccess<VisitingEntity>(chatId, visitingItem);
      } else {
        AppLog.error(
          result.exception?.message ?? 'ERROR - BookVisitApiImpl.bookVisit',
          name: 'BookVisitApiImpl.bookVisit - failed',
          error: result.exception,
        );
        return DataFailer<VisitingEntity>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitApiImpl.bookVisit - catch',
        error: e,
      );
      return DataFailer<VisitingEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<VisitingEntity>> cancelVisit(
      UpdateVisitParams params) async {
    const String endpoint = '/visit/update?attribute=status';

    try {
      final DataState<VisitingEntity> result =
          await ApiCall<VisitingEntity>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: json.encode(params.tocancelvisit()),
      );
      if (result is DataSuccess) {
        return DataSuccess<VisitingEntity>(result.data ?? '', result.entity);
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'BookVisitApiImpl.CancelVisit - Else',
        );
        return DataFailer<VisitingEntity>(
            CustomException('Failed to cancel visit. Please try again.'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitApiImpl.CancelVisit - catch',
        error: e,
      );
      return DataFailer<VisitingEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<VisitingEntity>> updateVisit(
      UpdateVisitParams params) async {
    const String endpoint = '/visit/update?attribute=date';
    try {
      final DataState<VisitingEntity> result =
          await ApiCall<VisitingEntity>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: json.encode(params.toupdatevisit()),
      );
      debugPrint('${params.toupdatevisit()}');
      if (result is DataSuccess) {
        return DataSuccess<VisitingEntity>(result.data ?? '', result.entity);
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'BookVisitApiImpl.UpdateVisit - Else',
        );
        return DataFailer<VisitingEntity>(
            CustomException('Failed to update visit. Please try again.'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitApiImpl.UpdateVisit - catch',
        error: e,
      );
      return DataFailer<VisitingEntity>(CustomException(e.toString()));
    }
  }
}
