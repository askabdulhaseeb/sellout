import '../../../../../core/enums/core/status_type.dart';

class GetOrderParams {
  const GetOrderParams({
    required this.user,
    required this.value,
    this.status,
  });

  final GetOrderUserType user;
  final String value;
  final StatusType? status;

  /// Build the endpoint dynamically, adding status only if present.
  String get endpoint {
    final Map<String, String> queryParams = <String, String>{
      user.key: value,
      if (status != null && status!.json.isNotEmpty)
        'order_status': status!.json,
    };
    final Uri uri = Uri(path: '/orders/query', queryParameters: queryParams);
    return uri.toString();
  }
}

enum GetOrderUserType {
  buyerId('buyer_id'),
  sellerId('seller_id');

  const GetOrderUserType(this.key);
  final String key;
}
