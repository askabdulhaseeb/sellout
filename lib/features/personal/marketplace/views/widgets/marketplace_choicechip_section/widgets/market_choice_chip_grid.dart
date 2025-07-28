import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/loaders/post_grid_loader.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../../providers/marketplace_provider.dart';

class MarketplaceChoiceGridWidget extends StatelessWidget {
  const MarketplaceChoiceGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, _) {
        final List<PostEntity>? posts = marketPro.choicePosts;
        if (marketPro.isLoading) {
          return const PostGridLoader();
        }
        if (posts == null || posts.isEmpty) {
          return Center(
            child: Text(
              'no_results'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (BuildContext context, int index) {
            return PostGridViewTile(post: posts[index]);
          },
        );
      },
    );
  }
}
