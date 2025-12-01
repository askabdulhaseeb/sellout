import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../domain/param/submit_shipping_param.dart';
import '../../../../providers/cart_provider.dart';

class SimplePostageSection extends StatefulWidget {
  const SimplePostageSection({super.key});

  @override
  State<SimplePostageSection> createState() => SimplePostageSectionState();
}

class SimplePostageSectionState extends State<SimplePostageSection> {
  Future<Map<String, PostEntity?>> _getPosts(CartProvider cartPro) async {
    await LocalPost.openBox;
    final Map<String, PostEntity?> posts = <String, PostEntity?>{};
    for (final PostageItemDetailEntity detail
        in cartPro.postageResponseEntity!.detail) {
      posts[detail.cartItemId] = await LocalPost().getPost(
        detail.postId,
        silentUpdate: true,
      );
    }
    return posts;
  }

  Future<Map<String, String>> _getConvertedPrices(CartProvider cartPro) async {
    final Map<String, String> prices = <String, String>{};
    final PostageDetailResponseEntity? postage = cartPro.postageResponseEntity;
    if (postage == null) return prices;

    final Map<String, PostageItemDetailEntity> detailById =
        <String, PostageItemDetailEntity>{
          for (final PostageItemDetailEntity d in postage.detail)
            d.cartItemId: d,
        };

    for (final ShippingItemParam item in cartPro.selectedShippingItems) {
      final PostageItemDetailEntity? detail = detailById[item.cartItemId];
      if (detail == null) continue;
      final RateEntity rate = detail.shippingDetails
          .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
          .where((RateEntity r) => r.objectId == item.objectId)
          .first; // Safe fallback
      prices[item.cartItemId] = await rate.getPriceStr();
    }

    return prices;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    if (cartPro.postageResponseEntity == null) return const SizedBox.shrink();
    final bool isLoading = cartPro.loadingPostage;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        if (!isLoading) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const PostageBottomSheet(),
          );
        }
      },
      child: ShadowContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${'postage'.tr()}:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              FutureBuilder<Map<String, PostEntity?>>(
                future: _getPosts(cartPro),
                builder:
                    (_, AsyncSnapshot<Map<String, PostEntity?>> snapPosts) {
                      if (!snapPosts.hasData) return const SizedBox.shrink();
                      final Map<String, PostEntity?> posts = snapPosts.data!;
                      return FutureBuilder<Map<String, String>>(
                        future: _getConvertedPrices(cartPro),
                        builder:
                            (_, AsyncSnapshot<Map<String, String>> snapPrices) {
                              if (!snapPrices.hasData)
                                return const SizedBox.shrink();
                              final Map<String, String> prices =
                                  snapPrices.data!;
                              final List<Widget> items = <Widget>[];

                              for (final PostageItemDetailEntity detail
                                  in cartPro.postageResponseEntity!.detail) {
                                final String cartId = detail.cartItemId;
                                final String title =
                                    posts[cartId]?.title ??
                                    'unknown_product'.tr();
                                final DeliveryType type =
                                    detail.originalDeliveryType;
                                final bool isFree =
                                    type == DeliveryType.freeDelivery;
                                final bool isFast =
                                    detail.fastDelivery.requested == true;
                                final bool isPaid = type == DeliveryType.paid;
                                final bool needsRates = isPaid || isFast;

                                String text = '';
                                bool italic = false;
                                Color? color;
                                bool deliveryNotAvailable = false;

                                if (prices.containsKey(cartId)) {
                                  text = prices[cartId]!;
                                } else if (needsRates) {
                                  deliveryNotAvailable = true;
                                } else if (isFree && !isFast) {
                                  text = 'free'.tr();
                                  italic = true;
                                } else {
                                  text = '';
                                }

                                if (text.isNotEmpty || deliveryNotAvailable) {
                                  items.add(
                                    _row(
                                      title,
                                      text,
                                      context,
                                      italic: italic,
                                      color: color,
                                      deliveryNotAvailable:
                                          deliveryNotAvailable,
                                    ),
                                  );
                                }
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: items,
                              );
                            },
                      );
                    },
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String trailing,
    BuildContext context, {
    bool isBold = false,
    bool italic = false,
    Color? color,
    bool deliveryNotAvailable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          if (deliveryNotAvailable)
            Expanded(
              child: Text(
                'remove_item_cart_continue_checkout'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Text(
              trailing,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
