import 'package:flutter/material.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/params/add_service_param.dart';

abstract interface class AddServiceRemoteApi {
  Future<DataState<bool>> addService(AddServiceParam params);
  Future<DataState<bool>> updateService(AddServiceParam params);
}

class AddServiceRemoteApiImpl implements AddServiceRemoteApi {
  @override
  Future<DataState<bool>> addService(AddServiceParam params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().callFormData(
        endpoint: '/service/create',
        requestType: ApiRequestType.post,
        fieldsMap: params.toMap(),
        attachments: params.attachments,
        isConnectType: true,
        isAuth: true,
      );
      if (result is DataSuccess) {
        debugPrint(result.data.toString());

        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(
          result.exception?.message.toString() ?? 'Add Service Failed',
          name: 'AddServiceRemoteApiImpl.addService - else',
          error: CustomException('Add Service Failed'),
        );
        return result;
      }
    } catch (e, stc) {
      AppLog.error(
        'Add Service Failed - $e',
        name: 'AddServiceRemoteApiImpl.addService - Catch $stc',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> updateService(AddServiceParam params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().callFormData(
        endpoint: 'service/update/${params.serviceID}',
        requestType: ApiRequestType.patch,
        fieldsMap: params.toMap(),
        attachments: params.attachments,
        isConnectType: true,
        isAuth: true,
      );
      if (result is DataSuccess) {
        debugPrint('this is the file ${result.data.toString()}');
        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(
          result.exception?.message.toString() ?? 'Update Service Failed',
          name: 'AddServiceRemoteApiImpl.updateService - else',
          error: CustomException('Update Service Failed'),
        );
        return result;
      }
    } catch (e, stc) {
      AppLog.error(
        'Update Service Failed - $e',
        name: 'AddServiceRemoteApiImpl.updateService - Catch $stc',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
