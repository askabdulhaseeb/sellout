import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/get_post_by_id_usecase.dart';
import '../profile_filter_section.dart';
import '../subwidgets/post_grid_view_tile.dart';

class ProfileStoreGridview extends StatelessWidget {
  const ProfileStoreGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    if (user?.uid == null) {
      return Center(child: Text('user_not_found'.tr()));
    }
    final GetPostByIdUsecase getPostByIdUsecase = GetPostByIdUsecase(locator());
    return FutureBuilder<DataState<List<PostEntity>>>(
      future: getPostByIdUsecase(user!.uid),
      initialData: LocalPost().postbyUid(user!.uid),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<PostEntity>>> snapshot) {
        if (!snapshot.hasData || snapshot.data?.entity == null) {
          return Center(child: Text('no_posts_found'.tr()));
        }
        final List<PostEntity> posts = snapshot.data!.entity!;
        if (posts.isEmpty) {
          return Center(child: Text('no_posts_found'.tr()));
        }
        posts.sort(
            (PostEntity a, PostEntity b) => b.createdAt.compareTo(a.createdAt));
        return Column(
          children: <Widget>[
            InDevMode(child: ProfileFilterSection(user: user)),
            GridView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                  childAspectRatio: 0.75),
              itemBuilder: (BuildContext context, int index) {
                return PostGridViewTile(post: posts[index]);
              },
            ),
          ],
        );
      },
    );
  }
}
