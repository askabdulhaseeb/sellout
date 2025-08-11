import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../domain/usecase/get_post_by_id_usecase.dart';
import '../subwidgets/profile_visit_gridview_tile.dart';

class ProfileMyViewingGridview extends StatelessWidget {
  const ProfileMyViewingGridview({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = LocalAuth.uid ?? '';
    final GetPostByIdUsecase getPostByIdUsecase = GetPostByIdUsecase(locator());

    return FutureBuilder<DataState<List<PostEntity>>>(
      future: getPostByIdUsecase(uid),
      initialData: LocalPost().postbyUid(uid),
      builder: (
        BuildContext context,
        AsyncSnapshot<DataState<List<PostEntity>>> snapshot,
      ) {
        final List<PostEntity> posts = snapshot.data?.entity ?? <PostEntity>[];

        posts.sort(
            (PostEntity a, PostEntity b) => b.createdAt.compareTo(a.createdAt));

        return posts.isEmpty
            ? Center(child: Text('no_posts_found'.tr()))
            : GridView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProfileVisitGridviewTile(post: posts[index]);
                },
              );
      },
    );
  }
}
