import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/custom_switch_list_tile.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../providers/cart_provider.dart';
import 'personal_cart_tile_delete_button.dart';
import 'personal_cart_tile_qty_section.dart';

class PersonalCartTile extends StatefulWidget {
  const PersonalCartTile({required this.item, super.key});
  final CartItemEntity item;

  @override
  State<PersonalCartTile> createState() => _PersonalCartTileState();
}

class _PersonalCartTileState extends State<PersonalCartTile> {
  bool isActive = true;

  Future<(PostEntity?, UserEntity?)> _loadData() async {
    final PostEntity? post = await LocalPost().getPost(widget.item.postID);
    final UserEntity? seller = await LocalUser().user(post?.createdBy ?? '');
    return (post, seller);
  }

  int calculateReviewPercentage(List<double> reviews, {double maxRating = 5}) {
    if (reviews.isEmpty) return 0;
    double total = reviews.reduce((double a, double b) => a + b);
    double possibleTotal = maxRating * reviews.length;
    return ((total / possibleTotal) * 100).floor();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FutureBuilder<(PostEntity?, UserEntity?)>(
      future: _loadData(),
      builder: (BuildContext context,
          AsyncSnapshot<(PostEntity?, UserEntity?)> snapshot) {
        final (PostEntity?, UserEntity?)? data = snapshot.data;
        final PostEntity? post = data?.$1;
        final UserEntity? seller = data?.$2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Seller info
            Row(
              children: <Widget>[
                Text.rich(
                  TextSpan(children: <InlineSpan>[
                    TextSpan(
                      text: '${'seller'.tr()}: ',
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                      ),
                    ),
                    TextSpan(
                      text: seller?.displayName ?? '',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: post?.deliveryType.bgColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: post?.deliveryType.color.withValues(alpha: 0.3) ??
                          Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color:
                            post?.deliveryType.color.withValues(alpha: 0.08) ??
                                Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: post?.deliveryType.color.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post?.deliveryType.code.tr() ?? 'na'.tr(),
                        style: textTheme.labelSmall?.copyWith(
                          color: post?.deliveryType.color,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${calculateReviewPercentage(seller?.listOfReviews ?? <double>[])}% ${'positive_feedback'.tr()}',
              style: textTheme.labelSmall?.copyWith(
                color: scheme.outline.withValues(alpha: 0.8),
              ),
            ),

            const SizedBox(height: 10),

            /// Product row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Product Image
                GestureDetector(
                  onTap: () {
                    AppNavigator.pushNamed(
                      PostDetailScreen.routeName,
                      arguments: <String, String>{'pid': widget.item.postID},
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                      imageURL: post?.imageURL,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                /// Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Title + Condition + Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              post?.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post?.condition.code.tr() ?? '',
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${CountryHelper.currencySymbolHelper(post?.currency)}${(widget.item.quantity * (post?.price ?? 0)).toStringAsFixed(0)}'
                                .toUpperCase(),
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      /// Size and Color Row
                      Row(
                        children: <Widget>[
                          if (widget.item.size != null)
                            Text(
                              '${'size'.tr()}: ${widget.item.size}',
                              style: textTheme.bodySmall,
                            ),
                          if (widget.item.color != null)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: widget.item.color.toColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      PersonalCartTileQtySection(item: widget.item, post: post),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Switch Row
            Row(
              spacing: AppSpacing.hSm,
              children: <Widget>[
                Text(
                  'need_fast_delivery'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CustomSwitch(
                  value: isActive,
                  onChanged: (bool val) {
                    setState(() => isActive = val);
                    debugPrint('Item switch toggled: $val');
                  },
                ),
              ],
            ),

            /// Save Later / Share
            SaveLaterWidget(item: widget.item),
          ],
        );
      },
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        PersonalCartTileDeleteButton(item: widget.item),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 15,
          width: 1,
          color: scheme.outline.withValues(alpha: 0.1),
        ),
        InkWell(
          onTap: () async {
            try {
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
          },
          child: Text(
            widget.item.type.tileActionCode.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: scheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 15,
          width: 1,
          color: scheme.outline.withValues(alpha: 0.1),
        ),
        Text(
          'share'.tr(),
          style: textTheme.bodySmall?.copyWith(
            color: scheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
