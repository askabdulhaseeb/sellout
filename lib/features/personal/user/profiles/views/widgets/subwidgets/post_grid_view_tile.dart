import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../post/domain/entities/post_entity.dart';

class ProfilePostGridViewTile extends StatelessWidget {
  const ProfilePostGridViewTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      padding: const EdgeInsets.all(4),
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
