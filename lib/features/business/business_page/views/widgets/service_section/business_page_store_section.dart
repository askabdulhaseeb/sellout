import 'package:flutter/material.dart';

import '../../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../../personal/post/data/sources/local/local_post.dart';
import '../../../../../personal/post/domain/entities/post_entity.dart';
import '../../../../../personal/user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../../../core/domain/entity/business_entity.dart';

class BusinessPageStoreSection extends StatelessWidget {
  const BusinessPageStoreSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    final List<PostEntity> posts =
        LocalPost().postbyUid(LocalAuth.uid).entity ?? <PostEntity>[];
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
        ),
        itemBuilder: (BuildContext context, int index) {
          return ProfilePostGridViewTile(post: posts[index]);
        },
      ),
    );
  }
}
