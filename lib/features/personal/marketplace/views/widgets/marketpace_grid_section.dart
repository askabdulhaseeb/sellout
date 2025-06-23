import 'package:flutter/material.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';

class MarketPlacePostsGrid extends StatelessWidget {
  const MarketPlacePostsGrid({required this.posts, super.key});
  final List<PostEntity> posts;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const SizedBox();
    }
    return GridView.builder(
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
  }
}
