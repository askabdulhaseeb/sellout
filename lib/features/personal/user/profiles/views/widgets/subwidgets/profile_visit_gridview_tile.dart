import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';

class ProfileVisitGridviewTile extends StatelessWidget {
  const ProfileVisitGridviewTile({required this.visit, super.key});
  final VisitingEntity visit;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      padding: const EdgeInsets.all(4),
      child: FutureBuilder<PostEntity?>(
        future: LocalPost().getPost(visit.postID),
        builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
          final PostEntity? post = snapshot.data;
          return Column(
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
                    child: CustomNetworkImage(imageURL: post?.imageURL),
                  ),
                ),
              ),
              //
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      post?.title ?? 'n/a',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post?.priceStr ?? 'n/a',
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
