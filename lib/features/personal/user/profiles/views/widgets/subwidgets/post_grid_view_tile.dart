import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';

class PostGridViewTile extends StatelessWidget {
  const PostGridViewTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostDetailScreen.routeName,
          arguments: <String, dynamic>{'pid': post.postId},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: CustomNetworkImage(imageURL: post.imageURL),
              ),
            ),
          ),
          Text(
            post.title,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            post.priceStr,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
