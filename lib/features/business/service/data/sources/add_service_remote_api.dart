import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/params/add_service_param.dart';

abstract interface class AddServiceRemoteApi {
  Future<DataState<bool>> addService(AddServiceParam params);
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
        isConnectType: false,
        isAuth: true,
      );
      if (result is DataSuccess) {
        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(
          'Add Service Failed',
          name: 'AddServiceRemoteApiImpl.addService - else',
          error: CustomException('Add Service Failed'),
        );
        return result;
      }
    } catch (e) {
      AppLog.error(
        'Add Service Failed - $e',
        name: 'AddServiceRemoteApiImpl.addService - Catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
