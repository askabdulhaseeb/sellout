import '../../../../../core/enums/business/services/service_category_type.dart';

class GetServiceCategoryParams {
  GetServiceCategoryParams({
    required this.type,
    this.nextKey,
  });
  final ServiceCategoryType type;
  final String? nextKey;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    if (nextKey != null) {
      map['nextKey'] = nextKey;
    }
    return map;
  }
}
