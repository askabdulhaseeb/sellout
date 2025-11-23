import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/custom_switch_list_tile.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../post/feed/views/widgets/post/widgets/section/icon_butoons/share_post_icon_button.dart';
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

/// Simple in-memory cache to avoid reloading post/seller data repeatedly per tile
class _CartTileDataCache {
  static final Map<String, Future<(PostEntity?, UserEntity?)>> _inFlight =
      <String, Future<(PostEntity?, UserEntity?)>>{};
  static final Map<String, (PostEntity?, UserEntity?)> _cache =
      <String, (PostEntity?, UserEntity?)>{};

  static Future<(PostEntity?, UserEntity?)> get(String postId) {
    // Return cached value if present
    final (PostEntity?, UserEntity?)? cached = _cache[postId];
    if (cached != null) return Future<(PostEntity?, UserEntity?)>.value(cached);

    // If a request is already in-flight for this postId, return it
    final Future<(PostEntity?, UserEntity?)>? flight = _inFlight[postId];
    if (flight != null) return flight;

    // Start a new load and memoize the Future to de-duplicate concurrent calls
    final Future<(PostEntity?, UserEntity?)> fut = _load(postId);
    _inFlight[postId] = fut;
    fut.then(((PostEntity?, UserEntity?) value) {
      _cache[postId] = value;
      _inFlight.remove(postId);
    }, onError: (_) {
      _inFlight.remove(postId);
    });
    return fut;
  }

  static Future<(PostEntity?, UserEntity?)> _load(String postId) async {
    final PostEntity? post = await LocalPost().getPost(postId);
    final UserEntity? seller = await LocalUser().user(post?.createdBy ?? '');
    return (post, seller);
  }
}

class _PersonalCartTileState extends State<PersonalCartTile>
    with AutomaticKeepAliveClientMixin<PersonalCartTile> {
  late bool isActive;
  DeliveryType? _deliveryType;
  late Future<(PostEntity?, UserEntity?)> _loadFuture;

  @override
  void initState() {
    super.initState();
    // Cache-backed future: avoids repeated loads across rebuilds/tiles
    _loadFuture = _loadData();
    // Initialize switch state from provider's fast-delivery list.
    // listen: false is safe here since we only want the initial value; the
    // widget updates the provider when toggled.
    final CartProvider provider =
        Provider.of<CartProvider>(context, listen: false);
    isActive = provider.fastDeliveryProducts.contains(widget.item.postID);
    if (isActive) {
      _deliveryType = DeliveryType.fastDelivery;
    }
  }

  Future<(PostEntity?, UserEntity?)> _loadData() async {
    return _CartTileDataCache.get(widget.item.postID);
  }

  int calculateReviewPercentage(List<double> reviews, {double maxRating = 5}) {
    if (reviews.isEmpty) return 0;
    double total = reviews.reduce((double a, double b) => a + b);
    double possibleTotal = maxRating * reviews.length;
    return ((total / possibleTotal) * 100).floor();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return FutureBuilder<(PostEntity?, UserEntity?)>(
      future: _loadFuture,
      builder: (BuildContext context,
          AsyncSnapshot<(PostEntity?, UserEntity?)> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Lightweight skeleton to reduce layout shift while loading
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.vSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                const SizedBox(width: AppSpacing.hSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        final (PostEntity?, UserEntity?)? data = snapshot.data;
        final PostEntity? post = data?.$1;
        final UserEntity? seller = data?.$2;

        // Prefer the local, potentially-updated delivery type. Fall back to
        // the post's delivery type or a safe default.
        final DeliveryType displayDeliveryType =
            _deliveryType ?? post?.deliveryType ?? DeliveryType.collection;

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
                  margin: const EdgeInsets.only(left: AppSpacing.sm),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: displayDeliveryType.bgColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: displayDeliveryType.color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color:
                            displayDeliveryType.color.withValues(alpha: 0.08),
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
                        color: displayDeliveryType.color.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: AppSpacing.hXs),
                      Text(
                        displayDeliveryType.code.tr(),
                        style: textTheme.labelSmall?.copyWith(
                          color: displayDeliveryType.color,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: AppSpacing.vXs),
            Text(
              '${calculateReviewPercentage(seller?.listOfReviews ?? <double>[])}% ${'positive_feedback'.tr()}',
              style: textTheme.labelSmall?.copyWith(
                color: scheme.outline.withValues(alpha: 0.8),
              ),
            ),

            const SizedBox(height: AppSpacing.vSm),

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
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: CustomNetworkImage(
                      imageURL: post?.imageURL,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.hSm),

                /// Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              post?.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.hSm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.08),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusXs),
                            ),
                            child: Text(
                              post?.condition.code.tr() ?? '',
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.hSm),
                          Text(
                            '${CountryHelper.currencySymbolHelper(post?.currency)}${(widget.item.quantity * (post?.price ?? 0)).toStringAsFixed(0)}'
                                .toUpperCase(),
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.vXs),

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
                              margin:
                                  const EdgeInsets.only(left: AppSpacing.sm),
                              width: AppSpacing.hMd,
                              height: AppSpacing.vMd,
                              decoration: BoxDecoration(
                                color: widget.item.color.toColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.vXs),
                      PersonalCartTileQtySection(item: widget.item, post: post),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.vSm),

            /// Switch Row
            if (widget.item.status == CartItemStatusType.cart)
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
                      // Update local UI state and persist change to provider's
                      // fast-delivery id list.
                      final CartProvider provider =
                          Provider.of<CartProvider>(context, listen: false);
                      setState(() {
                        debugPrint('fast delivery for ${widget.item.postID}');
                        isActive = val;
                        _deliveryType = val
                            ? DeliveryType.fastDelivery
                            : (post?.deliveryType ?? DeliveryType.collection);
                      });
                      if (val) {
                        provider.addFastDeliveryProduct(widget.item.postID);
                      } else {
                        provider.removeFastDeliveryProduct(widget.item.postID);
                      }
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

  @override
  bool get wantKeepAlive => true;
}

class SaveLaterWidget extends StatefulWidget {
  const SaveLaterWidget({required this.item, super.key});
  final CartItemEntity item;

  @override
  State<SaveLaterWidget> createState() => _SaveLaterWidgetState();
}

class _SaveLaterWidgetState extends State<SaveLaterWidget> {
  bool _isLoading = false;

  Future<void> _handleSaveLater() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
      final DataState<bool> result =
          await cartProvider.updateStatus(widget.item);

      if (mounted) {
        if (result is DataSuccess) {
          // Remove from fast delivery if present
          cartProvider.removeFastDeliveryProduct(widget.item.postID);
          AppSnackBar.showSnackBar(
            context,
            'Item status updated successfully'.tr(),
            color: Theme.of(context).colorScheme.primary,
          );
        } else if (result is DataFailer) {
          AppSnackBar.showSnackBar(
            context,
            result.exception?.message ?? 'Failed to update item status'.tr(),
            color: Theme.of(context).colorScheme.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showSnackBar(
          context,
          'Error: ${e.toString()}',
          color: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        PersonalCartTileDeleteButton(item: widget.item),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.hSm),
          height: AppSpacing.vMd,
          width: 1,
          color: scheme.outline.withValues(alpha: 0.1),
        ),
        InkWell(
          onTap: _isLoading ? null : _handleSaveLater,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_isLoading) ...<Widget>[
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(scheme.secondary),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                widget.item.type.tileActionCode.tr(),
                style: textTheme.bodySmall?.copyWith(
                  color: _isLoading ? scheme.outline : scheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.hSm),
          height: AppSpacing.vMd,
          width: 1,
          color: scheme.outline.withValues(alpha: 0.1),
        ),
                  SharePostButton(
            tappableWidget:
                  Text(
          'share'.tr(),
          style: textTheme.bodySmall?.copyWith(
            color: scheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
            postId: widget.item.postID,
          ),
       
      ],
    );
  }
}
