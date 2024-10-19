import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../domain/entities/post_entity.dart';
import '../../providers/feed_provider.dart';
import 'widgets/home_post_tile.dart';

class HomePostListSection extends StatelessWidget {
  const HomePostListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<DataState<List<PostEntity>>>(
        future: Provider.of<FeedProvider>(context, listen: false).getFeed(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState<List<PostEntity>>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<PostEntity> posts =
              snapshot.data?.entity ?? <PostEntity>[];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) =>
                HomePostTile(post: posts[index]),
          );
        },
      ),
    );
  }
}
