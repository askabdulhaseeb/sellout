import 'package:flutter/material.dart';

import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/get_post_by_id_usecase.dart';
import 'subwidgets/post_grid_view_tile.dart';

class ProfileGridSection extends StatelessWidget {
  const ProfileGridSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final GetPostByIdUsecase getPostByIdUsecase = GetPostByIdUsecase(locator());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<DataState<List<PostEntity>>>(
        future: getPostByIdUsecase(user?.uid),
        initialData: LocalPost().postbyUid(user?.uid),
        builder: (BuildContext context,
            AsyncSnapshot<DataState<List<PostEntity>>> snapshot) {
          final List<PostEntity> posts =
              snapshot.data?.entity ?? <PostEntity>[];
          return posts.isEmpty
              ? const Center(child: Text('No posts found'))
              : GridView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProfilePostGridViewTile(post: posts[index]);
                  },
                );
        },
      ),
    );
  }
}
