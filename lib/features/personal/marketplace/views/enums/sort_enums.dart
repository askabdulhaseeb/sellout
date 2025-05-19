import '../../../post/domain/entities/post_entity.dart';

enum SortOption {
  dateAscending('newly_list'),
  dateDescending('oldly_list'),
  priceAscending('lowest_price'),
  priceDescending('highest_price');

  const SortOption(this.displayName);

  final String displayName;

  // Method to sort posts based on the selected option
  static List<PostEntity> sortPosts(List<PostEntity> posts, SortOption option) {
    switch (option) {
      case SortOption.dateAscending:
        posts.sort((PostEntity a, PostEntity b) => a.createdAt
            .compareTo(b.createdAt)); // Assuming createdAt is a DateTime
        break;
      case SortOption.dateDescending:
        posts.sort(
            (PostEntity a, PostEntity b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.priceAscending:
        posts.sort((PostEntity a, PostEntity b) =>
            a.price.compareTo(b.price)); // Assuming price is a numeric value
        break;
      case SortOption.priceDescending:
        posts.sort((PostEntity a, PostEntity b) => b.price.compareTo(a.price));
        break;
    }
    return posts;
  }
}
