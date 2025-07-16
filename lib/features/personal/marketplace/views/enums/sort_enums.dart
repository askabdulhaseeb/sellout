import '../../../post/domain/entities/post_entity.dart';

enum SortOption {
  dateAscending(code: 'newly_list', json: 'date_asc'),
  dateDescending(code: 'oldly_list', json: 'date_desc'),
  priceAscending(code: 'lowest_price', json: 'low_to_high'),
  priceDescending(code: 'highest_price', json: 'high_to_low');

  const SortOption({required this.code, required this.json});

  final String code; // for localization key like 'newly_list'
  final String json; // for sending to API like 'price_desc'

  /// Localized text for UI
  String get displayText => code;

  /// Convert from JSON value
  static SortOption? fromJson(String? jsonValue) {
    return SortOption.values.firstWhere(
      (SortOption e) => e.json == jsonValue,
      orElse: () => SortOption.dateAscending, // default fallback
    );
  }

  /// Sort method
  static List<PostEntity> sortPosts(List<PostEntity> posts, SortOption option) {
    switch (option) {
      case SortOption.dateAscending:
        posts.sort(
            (PostEntity a, PostEntity b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.dateDescending:
        posts.sort(
            (PostEntity a, PostEntity b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.priceAscending:
        posts.sort((PostEntity a, PostEntity b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDescending:
        posts.sort((PostEntity a, PostEntity b) => b.price.compareTo(a.price));
        break;
    }
    return posts;
  }
}
