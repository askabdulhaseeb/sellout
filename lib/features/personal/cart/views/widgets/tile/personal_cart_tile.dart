import 'package:flutter/material.dart';

import '../../../../../../core/extension/int_ext.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../domain/entities/cart_item_entity.dart';

class PersonalCartTile extends StatelessWidget {
  const PersonalCartTile({required this.item, super.key});
  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
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
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: item.quantity == 1 ? null : () {},
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            item.quantity.putInStart(sign: '0', length: 2),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed:
                                item.quantity == post?.quantity ? null : () {},
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${item.quantity * (post?.price ?? 0)} ${post?.currency}'
                          .toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ShadowContainer(
                      onTap: () {},
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    InkWell(
                      onTap: () {
                        print('object');
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'save-later',
                          style: TextStyle(color: primaryColor, fontSize: 14),
                        ).tr(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
