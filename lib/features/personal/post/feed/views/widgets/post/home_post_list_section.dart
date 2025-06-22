import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../domain/entities/post_entity.dart';
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
          (_, __) => const _LoadingTile(),
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

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: 100,
                      color: Theme.of(context).dividerColor,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 13,
                      width: 60,
                      color: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ),
              Container(
                width: 26,
                height: 26,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 20,
                width: 100,
                color: Theme.of(context).dividerColor,
              ),
              Container(
                height: 20,
                width: 50,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 40,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 15,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 15,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
