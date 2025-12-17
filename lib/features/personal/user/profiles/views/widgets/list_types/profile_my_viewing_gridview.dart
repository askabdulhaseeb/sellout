import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../services/get_it.dart';
import '../../../domain/entities/user_entity.dart';
import '../../enums/profile_page_tab_type.dart';
import '../../providers/profile_viewing_posts_provider.dart';
import '../profile_filter_buttons.dart';
import 'profile_posts_grid_view.dart';

class ProfileMyViewingGridview extends StatelessWidget {
  const ProfileMyViewingGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewingPostsProvider>(
      create: (_) => ProfileViewingPostsProvider(locator(), userUid: user?.uid)
        ..loadPosts(),
      child: Column(
        spacing: 8,
        children: <Widget>[
          ProfileFilterSection(
            user: user,
            pageType: ProfilePageTabType.viewing,
          ),
          const ProfilePostsGridView<ProfileViewingPostsProvider>(
            childAspectRatio: 0.66,
          ),
        ],
      ),
    );
  }
}
