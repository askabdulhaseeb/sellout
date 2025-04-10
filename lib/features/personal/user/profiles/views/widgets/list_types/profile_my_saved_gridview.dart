import 'package:flutter/material.dart';

import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../data/sources/local/local_user.dart';
import '../subwidgets/post_grid_view_tile.dart';

class ProfileMySavedGridview extends StatelessWidget {
  const ProfileMySavedGridview({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEntity? user = LocalUser().userEntity(LocalAuth.uid ?? '');
    final List<String> saved = user?.saved ?? <String>[];
    return saved.isEmpty
        ? const Center(child: Text('My Saved Gridview'))
        : GridView.builder(
            itemCount: saved.length,
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                childAspectRatio: 0.7),
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<PostEntity?>(
                  future: LocalPost().getPost(saved[index]),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<PostEntity?> snapshot,
                  ) {
                    final PostEntity? post = snapshot.data;
                    return post == null
                        ? const SizedBox.expand()
                        : PostGridViewTile(post: post);
                  });
            },
          );
  }
}
