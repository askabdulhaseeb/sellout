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
                children: <TextSpan>[
                  TextSpan(
                    text: 'retry'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          decorationColor: Theme.of(context).primaryColor,
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
          return HomePostTile(post: posts[index]);
        },
        childCount: posts.length,
      ),
    );
  }
}
