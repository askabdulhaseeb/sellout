import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../../core/widgets/loaders/post_grid_loader.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../enums/profile_page_tab_type.dart';
import '../../providers/profile_provider.dart';
import '../profile_filter_buttons.dart';
import '../subwidgets/post_grid_view_tile.dart';

class ProfileStoreGridview extends StatefulWidget {
  const ProfileStoreGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  State<ProfileStoreGridview> createState() => _ProfileStoreGridviewState();
}

class _ProfileStoreGridviewState extends State<ProfileStoreGridview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadStorePosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: <Widget>[
        ProfileFilterSection(
          user: widget.user,
          pageType: ProfilePageTabType.store,
        ),
        Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider pro, _) {
            final List<PostEntity>? posts = pro.storePosts;
            if (pro.isLoading) {
              return const PostGridLoader();
            }
            if ((posts == null || posts.isEmpty) && !pro.isLoading) {
              return Center(
                  child: EmptyPageWidget(
                      icon: CupertinoIcons.photo,
                      childBelow: Text('no_posts_found'.tr())));
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: posts!.length,
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (BuildContext context, int index) {
                return PostGridViewTile(post: posts[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
