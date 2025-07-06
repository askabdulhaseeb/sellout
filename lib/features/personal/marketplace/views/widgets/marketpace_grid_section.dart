import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../providers/marketplace_provider.dart';

class MarketPlacePostsGrid extends StatelessWidget {
  const MarketPlacePostsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) {
        final List<PostEntity> posts = pro.posts ?? <PostEntity>[];

        if (posts.isEmpty) {
          return const SizedBox();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (BuildContext context, int index) {
            return PostGridViewTile(post: posts[index]);
          },
        );
      },
    );
  }
}
