import '../../../../../../core/enums/listing/core/listing_type.dart';
import 'base_profile_posts_provider.dart';

class ProfileViewingPostsProvider extends BaseProfilePostsProvider {
  ProfileViewingPostsProvider(super.usecase, {super.userUid});

  @override
  String get providerName => 'ProfileViewingPostsProvider';

  @override
  List<ListingType> get listingTypes => ListingType.viewingList;
}
