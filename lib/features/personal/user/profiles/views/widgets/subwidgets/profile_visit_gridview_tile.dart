import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';

class ProfileVisitGridviewTile extends StatelessWidget {
  const ProfileVisitGridviewTile({required this.visit, super.key});
  final VisitingEntity visit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post?.title ?? 'n/a',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post?.priceStr ?? 'n/a',
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InDevMode(
                  child: CustomIconButton(
                    icon: CupertinoIcons.calendar,
                    onPressed: () {},
                    bgColor: AppTheme.lightPrimary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
