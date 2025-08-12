import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../providers/profile_provider.dart';
import '../profile_filter_section.dart';
import '../subwidgets/post_grid_view_tile.dart';

class ProfileMyViewingGridview extends StatefulWidget {
  const ProfileMyViewingGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  State<ProfileMyViewingGridview> createState() =>
      _ProfileMyViewingGridviewState();
}

class _ProfileMyViewingGridviewState extends State<ProfileMyViewingGridview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadViewingPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: <Widget>[
        ProfileFilterSection(user: widget.user),
        Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider pro, _) {
            final List<PostEntity>? posts = pro.storePosts;

            if (pro.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (posts == null || posts.isEmpty) {
              return Center(child: Text('no_posts_found'.tr()));
            }

            return GridView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
