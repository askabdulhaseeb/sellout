import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../views/params/add_listing_param.dart';

abstract interface class AddListingRemoteApi {
  Future<DataState<String>> addListing(AddListingParam params);
  Future<DataState<String>> editListing(AddListingParam params);
}

class AddListingRemoteApiImpl extends AddListingRemoteApi {
  @override
  Future<DataState<String>> addListing(AddListingParam params) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().callFormData(
        endpoint: '/post/create',
        requestType: ApiRequestType.post,
        attachments: params.attachments,
        fieldsMap: params.toMap(),
        isAuth: true,
      );
      if (response is DataSuccess) {
        return DataSuccess<String>(response.data ?? '', null);
      } else {
        AppLog.error(response.exception?.message ?? 'something_wrong'.tr(),
            name: 'AddListingRemoteApiImpl-addListing else');
        return DataFailer<String>(CustomException(
            'Failed to add item: ${response.exception?.message}'));
      }
    } catch (e, stc) {
      AppLog.error('$e$stc', name: 'AddListingRemoteApiImpl-addListing catch');
      return DataFailer<String>(CustomException('Error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState<String>> editListing(AddListingParam params) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().callFormData(
        endpoint: '/post/update/${params.postID}',
        requestType: ApiRequestType.patch,
        attachments: params.attachments,
        fieldsMap: params.toMap(),
        isAuth: true,
      );
      if (response is DataSuccess) {
        return DataSuccess<String>(response.data ?? '', null);
      } else {
        AppLog.error(response.exception?.message ?? 'something_wrong'.tr(),
            name: 'AddListingRemoteApiImpl-editListing else');
        return DataFailer<String>(CustomException(
            'Failed to edit item: ${response.exception?.message}'));
      }
    } catch (e, stc) {
      AppLog.error('$e$stc', name: 'AddListingRemoteApiImpl-editListing catch');
      return DataFailer<String>(CustomException('Error: ${e.toString()}'));
    }
  }
}
