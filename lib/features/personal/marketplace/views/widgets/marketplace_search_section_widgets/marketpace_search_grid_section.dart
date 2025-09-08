import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../post/domain/entities/post/post_entity.dart';

import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../providers/marketplace_provider.dart';

class MarketPlaceSearchGrid extends StatelessWidget {
  const MarketPlaceSearchGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) {
        final List<PostEntity> posts = pro.posts ?? <PostEntity>[];
        if (posts.isEmpty) {
          return EmptyPageWidget(
            icon: Icons.search_off,
            childBelow: Text('no_posts_found'.tr()),
          );
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (BuildContext context, int index) {
            return PostGridViewTile(post: posts[index]);
          },
        );
      },
    );
  }
}
