import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../providers/cart_provider.dart';
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
        padding: const EdgeInsets.all(4),
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
            return Column(
              spacing: 10,
              children: <Widget>[
                // SelectItemFromCartWidget(
                //   post: post,
                //   item: item,
                //   onChanged: (bool? value) {},
                //   value: true,
                // ),
                Row(
                  children: <Widget>[
                    //image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomNetworkImage(
                        imageURL: post?.imageURL,
                        size: 60,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            spacing: 4,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  post?.title ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.1)),
                                child: Text(
                                  '${post?.condition.code.tr()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              if (item.size != null)
                                RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    children: <TextSpan>[
                                      const TextSpan(text: 'size:'),
                                      TextSpan(text: item.size),
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
                ),
                SaveLaterWidget(
                  item: item,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class SaveLaterWidget extends StatefulWidget {
  const SaveLaterWidget({required this.item, super.key});

  final CartItemEntity item;

  @override
  State<SaveLaterWidget> createState() => _SaveLaterWidgetState();
}

class _SaveLaterWidgetState extends State<SaveLaterWidget> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = AppTheme.primaryColor;
    Color secondaryColor = AppTheme.secondaryColor;
    return Row(
      spacing: 4,
      children: <Widget>[
        Text(
          'delete',
          style: TextStyle(color: primaryColor, fontSize: 12),
        ).tr(),
        Container(
          height: 15,
          width: 1,
          color: ColorScheme.of(context).outline.withValues(alpha: 0.1),
        ),
        InkWell(
          onTap: () async {
            try {
              setState(() {});
              final DataState<bool> result =
                  await Provider.of<CartProvider>(context, listen: false)
                      .updateStatus(widget.item);
              if (result is DataFailer) {
                AppSnackBar.showSnackBar(
                  context,
                  result.exception?.message ?? 'something_wrong',
                );
              }
            } catch (e) {
              AppSnackBar.showSnackBar(context, e.toString());
            }
            setState(() {});
          },
          child: Text(
            widget.item.type.tileActionCode.tr(),
            style: TextStyle(color: secondaryColor, fontSize: 12),
          ).tr(),
        ),
        Container(
          height: 15,
          width: 1,
          color: ColorScheme.of(context).outline.withValues(alpha: 0.1),
        ),
        Text(
          'share',
          style: TextStyle(color: secondaryColor, fontSize: 12),
        ).tr(),
      ],
    );
  }
}

// class SelectItemFromCartWidget extends StatelessWidget {
//   const SelectItemFromCartWidget({
//     required this.item,
//     required this.post,
//     required this.value,
//     required this.onChanged,
//     super.key,
//   });
//   final CartItemEntity item;
//   final PostEntity post;
//   final bool value;
//   final ValueChanged<bool?> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     CartProvider pro = Provider.of<CartProvider>(context, listen: false);
//     return Row(
//       children: <Widget>[
//         Checkbox(
//           value: value,
//           onChanged: onChanged,
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text.rich(
//                   TextSpan(text: 'seller:'.tr(), children: <InlineSpan>[
//                     const TextSpan(text: ' '),
//                     TextSpan(
//                         text: post.createdBy,
//                         style: TextTheme.of(context).labelLarge)
//                   ]),
//                   style: TextTheme.of(context).labelLarge?.copyWith(
//                       color: ColorScheme.of(context)
//                           .outline
//                           .withValues(alpha: 0.6))),
             
//                 const SizedBox(height: 4),
//                 Text(post.listOfReviews '% positive feedback'.tr(),
//                     style: TextTheme.of(context).labelSmall?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: ColorScheme.of(context)
//                             .outline
//                             .withValues(alpha: 0.6))),
              
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
