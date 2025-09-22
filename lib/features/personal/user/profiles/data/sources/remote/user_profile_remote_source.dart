import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../../attachment/data/attchment_model.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/supporter_detail_entity.dart';
import '../../../views/params/add_remove_supporter_params.dart';
import '../../../views/params/update_user_params.dart';
import '../../models/supporter_detail_model.dart';
import '../local/local_user.dart';

abstract interface class UserProfileRemoteSource {
  Future<DataState<UserEntity?>> byUID(String value);
  Future<DataState<List<AttachmentEntity>>> updateProfilePicture(
      PickedAttachment photo);
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo);
  Future<DataState<String>> addRemoveSupporters(
      AddRemoveSupporterParams params);
  Future<DataState<bool?>> deleteUser(String value);
}

class UserProfileRemoteSourceImpl implements UserProfileRemoteSource {
  @override
  Future<DataState<UserEntity?>> byUID(String value) async {
    if (value.isEmpty) {
      return DataFailer<UserEntity?>(CustomException('User ID is null'));
    }

    final String endpoint = '/noAuth/entity/$value';

    try {
      // Check local cache first
      ApiRequestEntity? request = await LocalRequestHistory().request(
        endpoint: endpoint,
        duration:
            kDebugMode ? const Duration(minutes: 10) : const Duration(hours: 1),
      );

      if (request != null) {
        final DataState<UserEntity?> local = LocalUser().userState(value);
        if (local is DataSuccess<UserEntity?> && local.entity != null) {
          return local;
        }
      }

      // Call network
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: false,
        isConnectType: false,
        requestType: ApiRequestType.get,
      );

      if (result is DataSuccess<bool>) {
        final String rawJson = result.data ?? '';

        if (rawJson.isEmpty) {
          return DataFailer<UserEntity?>(
              CustomException('User response empty'));
        }

        // ⛔ No isolate: just parse normally
        final UserEntity entity = UserModel.fromRawJson(rawJson);

        // Save to local cache
        await LocalUser().save(entity);

        return DataSuccess<UserEntity>(rawJson, entity);
      }

      return DataFailer<UserEntity?>(CustomException('User not found'));
    } catch (e) {
      debugPrint('GetUserAPI.user: catch $e - $endpoint');
      return DataFailer<UserEntity?>(CustomException('User not found'));
    }
  }

  @override
  Future<DataState<List<AttachmentEntity>>> updateProfilePicture(
      PickedAttachment attachments) async {
    try {
      final DataState<String> result = await ApiCall<String>().callFormData(
        fileKey: 'file',
        endpoint: '/user/profilePic?action=update',
        requestType: ApiRequestType.post,
        attachments: <PickedAttachment>[attachments],
      );
      if (result is DataSuccess<String>) {
        debugPrint('my data:${result.data ?? ''}');
        Map<String, dynamic> myData = jsonDecode(result.data!);
        // ✅ Convert JSON to List<AttachmentEntity>
        List<AttachmentEntity> profilephoto =
            (myData['profile_image'] as List<dynamic>)
                .map((dynamic e) => AttachmentModel.fromJson(e))
                .toList();
        // ✅ Update LocalAuth.currentUser properly and save it to Hive
        LocalAuth.currentUser!.profileImage = profilephoto;
        return DataSuccess<List<AttachmentEntity>>('', profilephoto);
      } else {
        AppLog.error(result.exception!.message,
            name: 'GetUserAPI.updateProfilePicture: else');
        return DataFailer<List<AttachmentEntity>>(CustomException(
            result.exception?.message ?? 'something_wrong'.tr()));
      }
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'GetUserAPI.updateProfilePicture: catch');
      return DataFailer<List<AttachmentEntity>>(
          CustomException('something_wrong'.tr()));
    }
  }

  @override
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams params) async {
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: '/user/update/${LocalAuth.uid ?? ''}',
        requestType: ApiRequestType.patch,
        body: json.encode(params.toMap()),
      );
      AppLog.info(params.toMap().toString(),
          name: 'user\'s attributes to be updated');
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

  @override
  Future<DataState<String>> addRemoveSupporters(
      AddRemoveSupporterParams params) async {
    AppLog.info('${params.action.value}ing supporter',
        name: 'UserProfileRemoteImpl.addRemoveSupporters - start');

    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: '/user/add/support?action=${params.action.value}',
        requestType: ApiRequestType.patch,
        body: json.encode(params.toJson()),
      );
      debugPrint(result.data);
      AppLog.info('API called',
          name: 'UserProfileRemoteImpl.addRemoveSupporters - after API call');
      if (result is DataSuccess<String>) {
        final String responseData = result.data ?? '';
        debugPrint('Raw API Response: $responseData');
        if (LocalAuth.currentUser == null) {
          return DataFailer<String>(CustomException('User not signed in.'));
        }
        if (params.action == SupporterAction.add) {
          final Map<String, dynamic> supporterMap = jsonDecode(responseData);
          final SupporterDetailEntity supporterEntity =
              SupporterDetailModel.fromMap(supporterMap['user_detail'])
                  .toEntity();
          final List<SupporterDetailEntity> existingSupporters =
              LocalAuth.currentUser?.supporting ?? <SupporterDetailEntity>[];

          final bool alreadySupporting = existingSupporters.any(
              (SupporterDetailEntity element) =>
                  element.userID == supporterEntity.userID);

          if (!alreadySupporting) {
            final List<SupporterDetailEntity> updatedSupporting =
                List<SupporterDetailEntity>.from(existingSupporters)
                  ..add(supporterEntity);

            final CurrentUserEntity updatedUser =
                LocalAuth.currentUser!.copyWith(supporting: updatedSupporting);
            await LocalAuth().signin(updatedUser);
            AppLog.info('Supporter added',
                name: 'UserProfileRemoteImpl.addRemoveSupporters');
          } else {
            AppLog.info('Duplicate supporter ignored',
                name: 'UserProfileRemoteImpl.addRemoveSupporters');
          }
        } else if (params.action == SupporterAction.unfollow) {
          AppLog.info('Removing supporter',
              name: 'UserProfileRemoteImpl.addRemoveSupporters');

          final List<SupporterDetailEntity> updatedList =
              List<SupporterDetailEntity>.from(
                  LocalAuth.currentUser?.supporting ?? <dynamic>[]);

          updatedList.removeWhere((SupporterDetailEntity element) =>
              element.userID == params.supporterId);

          final CurrentUserEntity updatedUser =
              LocalAuth.currentUser!.copyWith(supporting: updatedList);
          await LocalAuth().signin(updatedUser);

          AppLog.info('Supporter removed',
              name: 'UserProfileRemoteImpl.addRemoveSupporters');
        }

        return DataSuccess<String>(responseData, result.entity);
      } else {
        AppLog.error('API returned failure: ${result.exception?.message}',
            name: 'UserProfileRemoteImpl.addRemoveSupporters');
        return DataFailer<String>(
          CustomException(result.exception?.message ?? 'something_wrong'),
        );
      }
    } catch (e, st) {
      AppLog.error('Exception caught: $e',
          name: 'UserProfileRemoteImpl.addRemoveSupporters',
          error: CustomException(e.toString()),
          stackTrace: st);
      return DataFailer<String>(CustomException('something_wrong'));
    }
  }

  @override
  Future<DataState<bool?>> deleteUser(String value) async {
    if (value.isEmpty) {
      return DataFailer<bool?>(CustomException('User ID is null'));
    }

    final String endpoint = '/noAuth/entity/$value';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.delete,
      );
      if (result is DataSuccess<bool>) {
        await LocalAuth().signout();
        return DataSuccess<bool>('', true);
      }
      return DataFailer<bool?>(CustomException('user not deletd'));
    } catch (e) {
      return DataFailer<bool?>(CustomException('User not deleted'));
    }
  }
}
