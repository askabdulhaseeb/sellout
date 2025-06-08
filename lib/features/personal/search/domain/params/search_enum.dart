enum SearchEntityType { posts, services, users }
enum SortBy { bestMatch, newest, popular }

class SearchParams {
  SearchParams({
    required this.entityType,
    required this.query,
    this.sortBy = SortBy.bestMatch,
    this.pageSize = 4,
    this.lastEvaluatedKey = '',
  });

  final SearchEntityType entityType;
  final String query;
  final SortBy sortBy;
  final int pageSize;
  final String lastEvaluatedKey;

  SearchParams copyWith({
    SearchEntityType? entityType,
    String? query,
    SortBy? sortBy,
    int? pageSize,
    String? lastEvaluatedKey,
  }) {
    return SearchParams(
      entityType: entityType ?? this.entityType,
      query: query ?? this.query,
      sortBy: sortBy ?? this.sortBy,
      pageSize: pageSize ?? this.pageSize,
      lastEvaluatedKey: lastEvaluatedKey ?? this.lastEvaluatedKey,
    );
  }
}
