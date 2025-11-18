import '../entity/service_category_entity.dart';

class GetServiceCategoryParams {
  GetServiceCategoryParams({
    required this.type,
    this.nextKey,
  });
  final ServiceCategoryEntity type;
  final String? nextKey;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (nextKey != null) {
      map['nextKey'] = nextKey;
    }
    return map;
  }
}
