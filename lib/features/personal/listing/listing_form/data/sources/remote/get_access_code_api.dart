import '../../../../../../../core/sources/api_call.dart';

class GetAccessCodeApi {
  Future<String?> getCode({String? oldCode}) async {
    if (oldCode != null && oldCode.isNotEmpty) return oldCode;
    // Request
    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: '/post/getCode',
      isAuth: false,
      isConnectType: false,
      requestType: ApiRequestType.get,
    );

    if (result is DataSuccess) {
      final String data = result.data ?? '';
      if (data.isEmpty) return null;
      final dynamic dataMap = json.decode(data);
      return dataMap['code'];
    } else {
      return null;
    }
  }
}
