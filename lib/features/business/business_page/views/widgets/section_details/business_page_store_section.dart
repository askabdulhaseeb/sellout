import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../personal/post/data/sources/local/local_post.dart';
import '../../../../../personal/post/domain/entities/post_entity.dart';
import '../../../../../personal/user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../../../core/domain/entity/business_entity.dart';
import '../../providers/business_page_provider.dart';

class BusinessPageStoreSection extends StatelessWidget {
  const BusinessPageStoreSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    final List<PostEntity> localPosts =
        LocalPost().postbyBusinessID(business.businessID).entity ??
            <PostEntity>[];
    return Consumer<BusinessPageProvider>(builder: (
      BuildContext context,
      BusinessPageProvider pagePro,
      _,
    ) {
      return FutureBuilder<DataState<List<PostEntity>>>(
          future: pagePro.getPostByID(business.businessID ?? ''),
          initialData: DataSuccess<List<PostEntity>>('', localPosts),
          builder: (
            BuildContext context,
            AsyncSnapshot<DataState<List<PostEntity>>> snapshot,
          ) {
            final List<PostEntity> posts = snapshot.data?.entity ?? localPosts;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                    childAspectRatio: 0.7),
                itemBuilder: (BuildContext context, int index) {
                  return PostGridViewTile(post: posts[index]);
                },
              ),
            );
          });
    });
  }
}
