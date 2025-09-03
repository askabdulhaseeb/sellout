import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/loaders/home_post_loader.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../../providers/feed_provider.dart';
import 'widgets/home_post_tile.dart';

class HomePostListSection extends StatelessWidget {
  const HomePostListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PostEntity> posts = context.watch<FeedProvider>().posts;
    final bool isLoading = context.watch<FeedProvider>().feedLoading;

    if (isLoading && posts.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const HomePostLoader(),
          childCount: 2,
        ),
      );
    }
    if (!isLoading && posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              SizedBox(
                width: 100,
                child: CustomElevatedButton(
                  onTap: () {
                    context.read<FeedProvider>().loadInitialFeed('post');
                  },
                  title: 'retry'.tr(),
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return HomePostTile(post: posts[index]);
        },
        childCount: posts.length,
      ),
    );
  }
}
