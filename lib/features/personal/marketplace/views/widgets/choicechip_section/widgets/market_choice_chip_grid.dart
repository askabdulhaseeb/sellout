import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, __) => const LoadingPostTile(),
          );
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

class LoadingPostTile extends StatelessWidget {
  const LoadingPostTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            height: 330,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(
          height: 80,
          child: Column(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 2),
              Container(
                width: 100,
                height: 15,
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Container(
                width: 100,
                height: 15,
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Container(
                width: 40,
                height: 15,
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
