// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import '../../../../data/sources/local/local_post.dart';
// import '../../../../domain/entities/post_entity.dart';
// import '../../providers/feed_provider.dart';
// import 'widgets/home_post_tile.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../data/sources/local/local_feed.dart';
import '../../../../domain/entities/post_entity.dart';
import 'widgets/home_post_tile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePostListSection extends HookWidget {
  const HomePostListSection({required this.endpointHash, super.key});
  final String endpointHash;

  @override
  Widget build(BuildContext context) {
    useListenable(LocalFeed.box.listenable());
    final List<PostEntity> posts = LocalFeed.getPostsForEndpoint(endpointHash);

    final bool isLoading = posts.isEmpty;

    if (isLoading) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const _LoadingTile(),
          childCount: 2,
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
          // Header
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
          // Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          // Title + price
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
          // Buttons
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
