import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../views/params/add_address_param.dart';

abstract interface class AddAddressRemoteSource {
  Future<DataState<bool>> addAddress(AddressParams params);
  Future<DataState<bool>> updateAddress(AddressParams params);
}

class AddAddressRemoteSourceImpl extends AddAddressRemoteSource {
  @override
  Future<DataState<bool>> addAddress(AddressParams params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/user/add/address',
        requestType: ApiRequestType.patch,
        isAuth: true,
        body: json.encode(params.toMap()),
      );
      if (result is DataSuccess<bool>) {
        AppLog.info('address added successfully',
            name: 'AddAddressRemoteSourceImpl.addAddress - success');
        final Map<String, dynamic> decoded = jsonDecode(result.data ?? '{}');
        final List<AddressEntity> updatedAddressList =
            (decoded['updatedAddress'] as List<dynamic>)
                .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
                .toList();
        // Use updateOrAddAddress for the last/added address
        if (updatedAddressList.isNotEmpty) {
          await LocalAuth().updateOrAddAddress(updatedAddressList);
        }
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'AddAddressRemoteSourceImpl.addAddress - else');
        return DataFailer<bool>(
          result.exception ??
              CustomException(
                  result.exception?.reason ?? 'something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(e.toString(),
          name: 'AddAddressRemoteSourceImpl.addAddress - catch',
          stackTrace: stc);
      return DataFailer<bool>(
        CustomException(e.toString()),
      );
    }
  }

  @override
  Future<DataState<bool>> updateAddress(AddressParams params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/user/update/address?action=${params.action}',
        requestType: ApiRequestType.patch,
        isAuth: true,
        body: json.encode(params.toMap()),
      );
      if (result is DataSuccess<bool>) {
        AppLog.info(result.data.toString(),
            name: 'AddAddressRemoteSourceImpl.updateAddress');
        final Map<String, dynamic> decoded = jsonDecode(result.data ?? '{}');
        final List<AddressEntity> updatedAddressList =
            (decoded['updatedAddress'] as List<dynamic>)
                .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
                .toList();
        // Use updateOrAddAddress for the last/updated address
        if (updatedAddressList.isNotEmpty) {
          await LocalAuth().updateOrAddAddress(updatedAddressList);
        }
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'AddAddressRemoteSourceImpl.updateAddress - else');
        return DataFailer<bool>(
          result.exception ??
              CustomException(
                  result.exception?.reason ?? 'something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(e.toString(),
          name: 'AddAddressRemoteSourceImpl.updateAddress - catch',
          stackTrace: stc);
      return DataFailer<bool>(
        CustomException(e.toString()),
      );
    }
  }
}
