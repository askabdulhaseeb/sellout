import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../../../listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../domain/entities/user_entity.dart';
import '../../enums/profile_page_tab_type.dart';
import '../../providers/profile_store_posts_provider.dart';
import '../profile_filter_buttons.dart';
import 'profile_posts_grid_view.dart';

class ProfileStoreGridview extends StatelessWidget {
  const ProfileStoreGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isOwnProfile = user?.uid == LocalAuth.uid;
    return ChangeNotifierProvider<ProfileStorePostsProvider>(
      create: (_) =>
          ProfileStorePostsProvider(locator(), userUid: user?.uid)..loadPosts(),
      child: Column(
        spacing: 8,
        children: <Widget>[
          ProfileFilterSection(user: user, pageType: ProfilePageTabType.store),
          ProfilePostsGridView<ProfileStorePostsProvider>(
            childAspectRatio: 0.6,
            showStartSellingButton: isOwnProfile,
            onStartSelling: isOwnProfile
                ? () {
                    final PersonalBottomNavProvider? nav =
                        Provider.of<PersonalBottomNavProvider?>(
                          context,
                          listen: false,
                        );
                    if (nav != null) {
                      nav.setCurrentTabIndex(3);
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute<StartListingScreen>(
                        builder: (_) => const StartListingScreen(),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
