import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../../core/widgets/loaders/post_grid_loader.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../services/get_it.dart';
import '../../../domain/entities/user_entity.dart';
import '../../enums/profile_page_tab_type.dart';
import '../../providers/profile_viewing_posts_provider.dart';
import '../profile_filter_buttons.dart';
import '../subwidgets/post_grid_view_tile.dart';

class ProfileMyViewingGridview extends StatelessWidget {
  const ProfileMyViewingGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewingPostsProvider>(
      create: (_) =>
          ProfileViewingPostsProvider(locator(), userUid: user?.uid)
            ..loadPosts(),
      child: Column(
        spacing: 8,
        children: <Widget>[
          ProfileFilterSection(
            user: user,
            pageType: ProfilePageTabType.viewing,
          ),
          Consumer<ProfileViewingPostsProvider>(
            builder:
                (BuildContext context, ProfileViewingPostsProvider pro, _) {
                  final List<PostEntity>? posts = pro.posts;
                  if (pro.isLoading) {
                    return const PostGridLoader();
                  }
                  if (posts == null || posts.isEmpty) {
                    return Center(
                      child: EmptyPageWidget(
                        icon: CupertinoIcons.photo,
                        childBelow: Text('no_posts_found'.tr()),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: posts.length,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6.0,
                          mainAxisSpacing: 6.0,
                          childAspectRatio: 0.66,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return PostGridViewTile(post: posts[index]);
                    },
                  );
                },
          ),
        ],
      ),
    );
  }
}
