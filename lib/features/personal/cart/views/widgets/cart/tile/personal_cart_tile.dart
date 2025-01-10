import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../domain/entities/cart/cart_item_entity.dart';
import 'personal_cart_tile_qty_section.dart';
import 'personal_cart_tile_trailing_section.dart';

class PersonalCartTile extends StatelessWidget {
  const PersonalCartTile({required this.item, super.key});
  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ShadowContainer(
        onTap: () {
          // TODO: POST DETAIL SCREEN
        },
        child: FutureBuilder<PostEntity?>(
          future: LocalPost().getPost(item.postID),
          builder: (
            BuildContext context,
            AsyncSnapshot<PostEntity?> snapshot,
          ) {
            final PostEntity? post = snapshot.data;
            return Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    imageURL: post?.imageURL,
                    size: 100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post?.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall,
                              children: <TextSpan>[
                                TextSpan(text: '${post?.condition.code.tr()}'),
                                if (item.size != null)
                                  TextSpan(
                                      text: ' | ${'size'.tr()}: ${item.size}'),
                              ],
                            ),
                          ),
                          if (item.color != null)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item.color.toColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      PersonalCartTileQtySection(item: item, post: post),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                PersonalCartTileTrailingSection(item: item, post: post),
              ],
            );
          },
        ),
      ),
    );
  }
}
