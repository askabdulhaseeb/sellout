import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../../core/widgets/loaders/home_post_loader.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../../providers/feed_provider.dart';
import 'widgets/home_post_tile.dart';

class HomePostListSection extends StatelessWidget {
  const HomePostListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final FeedProvider feedProvider = context.watch<FeedProvider>();
    final List<PostEntity> posts = feedProvider.posts;

    if (feedProvider.feedLoading && posts.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const HomePostLoader(),
          childCount: 2,
        ),
      );
    }

    if (!feedProvider.feedLoading && posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: EmptyPageWidget(
            icon: Icons.wifi_off,
            childBelow: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '${'something_wrong'.tr()}? ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'retry'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.read<FeedProvider>().loadInitialFeed('post');
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == posts.length) {
            // Bottom loader or “no more posts”
            if (feedProvider.feedLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (feedProvider.noMorePosts) {
              return const SizedBox.shrink();
            } else {
              return const SizedBox.shrink(); // safeguard fallback
            }
          }

          return HomePostTile(post: posts[index]);
        },
        childCount: posts.length + 1,
      ),
    );
  }
}
