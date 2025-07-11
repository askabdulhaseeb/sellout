import 'package:easy_localization/easy_localization.dart';
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
    return FutureBuilder<UserEntity?>(
      future: LocalUser().user(LocalAuth.uid ?? ''),
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('my_saved_posts'.tr()));
        }

        final List<String> saved = snapshot.data?.saved ?? <String>[];

        if (saved.isEmpty) {
          return Center(child: Text('my_saved_posts'.tr()));
        }

        return GridView.builder(
          itemCount: saved.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder<PostEntity?>(
              future: LocalPost().getPost(saved[index]),
              builder:
                  (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
                final PostEntity? post = snapshot.data;
                return post == null
                    ? const SizedBox.expand()
                    : PostGridViewTile(post: post);
              },
            );
          },
        );
      },
    );
  }
}
