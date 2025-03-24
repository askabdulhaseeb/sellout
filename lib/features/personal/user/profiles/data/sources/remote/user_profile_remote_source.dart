import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../views/params/update_user_params.dart';
import '../local/local_user.dart';

abstract interface class UserProfileRemoteSource {
  Future<DataState<UserEntity?>> byUID(String value);
  Future<DataState<bool>> updateProfilePicture(PickedAttachment photo);
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo);
}

class UserProfileRemoteSourceImpl implements UserProfileRemoteSource {
  @override
  Future<DataState<UserEntity?>> byUID(String value) async {
    if (value.isEmpty) {
      return DataFailer<UserEntity?>(CustomException('User ID is null'));
    }
    final String endpoint = '/noAuth/entity/$value';
    try {
      ApiRequestEntity? request = await LocalRequestHistory().request(
          endpoint: endpoint,
          duration: kDebugMode
              ? const Duration(minutes: 10)
              : const Duration(hours: 1));
      if (request != null) {
        final DataState<UserEntity?> local = LocalUser().userState(value);
        if (local is DataSuccess<UserEntity?> && local.entity != null) {
          return local;
        }
      }
      //
      //
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: false,
        isConnectType: false,
        requestType: ApiRequestType.get,
      );
      //
      if (result is DataSuccess<bool>) {
        final String data = result.data ?? '';
        final UserEntity entity = UserModel.fromRawJson(data);
        await LocalUser().save(entity);
        return DataSuccess<UserEntity>(data, entity);
      }
      return DataFailer<UserEntity?>(CustomException('User not found'));
    } catch (e) {
      debugPrint('GetUserAPI.user: catch $e - $endpoint');
    }
    return DataFailer<UserEntity?>(CustomException('User not found'));
  }

  @override
  Future<DataState<bool>> updateProfilePicture(
      PickedAttachment attachments) async {
    try {
      final DataState<String> result = await ApiCall<String>().callFormData(
        endpoint: '/user/profilePic?action=update',
        requestType: ApiRequestType.post,
        attachments: <PickedAttachment>[attachments],
      );
      if (result is DataSuccess<String>) {
        debugPrint('my data:${result.data ?? ''}');

        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(result.exception!.message,
            name: 'GetUserAPI.updateProfilePicture: else');
        return DataFailer<bool>(CustomException(
            result.exception?.message ?? 'something_wrong'.tr()));
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'GetUserAPI.updateProfilePicture: else');
      return DataFailer<bool>(CustomException('something_wrong'));
    }
  }

  @override
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams params) async {
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: '/user/update/${params.uid}',
        requestType: ApiRequestType.patch,
        body: json.encode(params.toMap()),
      );
      if (result is DataSuccess<String>) {
        return DataSuccess<String>(result.data ?? '', result.data);
      } else {
        AppLog.error(result.exception!.message,
            name: 'UserRepositoryImpl.updateProfileDetail: else');
        return DataFailer<String>(
            CustomException(result.exception?.message ?? 'something_wrong'));
      }
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'UserRepositoryImpl.updateProfileDetail: catch');
      return DataFailer<String>(CustomException('something_wrong'));
    }
  }
}
