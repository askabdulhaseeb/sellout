import '../../../marketplace/views/enums/sort_enums.dart';

enum SearchEntityType { posts, services, users }

class SearchParams {
  SearchParams({
    required this.entityType,
    required this.query,
    this.sortBy = SortOption.newlyList,
    this.pageSize = 4,
    this.lastEvaluatedKey,
    this.lat,
    this.lon,
  });

  final SearchEntityType entityType;
  final String query;
  final SortOption sortBy;
  final int pageSize;
  final String? lastEvaluatedKey;
  final double? lat;
  final double? lon;

  /// Builds “/search?…” with only the non‑null parameters.
  String get endpoint {
    final Map<String, String> qp = <String, String>{
      'entity_type': entityType.name,
      'query': query,
      'sort_by': sortBy.name,
      'page_size': pageSize.toString(),
    };

    if (lastEvaluatedKey?.isNotEmpty ?? false) {
      qp['last_evaluated_key'] = lastEvaluatedKey!;
    }
    if (lat != null) {
      qp['lat'] = lat!.toString();
    }
    if (lon != null) {
      qp['lon'] = lon!.toString();
    }

    return Uri(path: '/search', queryParameters: qp).toString();
  }
}
