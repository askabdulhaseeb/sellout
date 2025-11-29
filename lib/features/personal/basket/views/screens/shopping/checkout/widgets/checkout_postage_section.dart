import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../../domain/param/submit_shipping_param.dart';
import '../../../../providers/cart_provider.dart';

class SimplePostageSection extends StatefulWidget {
  const SimplePostageSection({super.key});

  @override
  State<SimplePostageSection> createState() => SimplePostageSectionState();
}

class SimplePostageSectionState extends State<SimplePostageSection> {
  // Fetch posts from local storage
  Future<Map<String, PostEntity?>> _getPosts(CartProvider cartPro) async {
    await LocalPost.openBox;
    final Map<String, PostEntity?> posts = <String, PostEntity?>{};
    for (final String id in cartPro.postageResponseEntity!.detail.keys) {
      posts[id] = await LocalPost().getPost(id, silentUpdate: true);
    }
    return posts;
  }

  Future<Map<String, String>> _getConvertedPrices(CartProvider cartPro) async {
    final Map<String, String> prices = <String, String>{};
    final PostageDetailResponseEntity? postage = cartPro.postageResponseEntity;
    if (postage == null) return prices;
    // Build a lookup map for cartItemId -> PostageItemDetailEntity
    final Map<String, PostageItemDetailEntity> detailByCartId =
        <String, PostageItemDetailEntity>{
      for (final PostageItemDetailEntity detail in postage.detail.values)
        detail.cartItemId: detail
    };
    for (final ShippingItemParam item in cartPro.selectedShippingItems) {
      final String cartItemId = item.cartItemId;
      final String objectId = item.objectId;
      final PostageItemDetailEntity? detail = detailByCartId[cartItemId];
      if (detail == null) continue;
      final Iterable<RateEntity> allRates = detail.shippingDetails
          .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered);
      final RateEntity? rate = allRates.cast<RateEntity?>().firstWhere(
            (RateEntity? rate) => rate?.objectId == objectId,
            orElse: () => null,
          );
      if (rate == null) continue;
      prices[cartItemId] = await rate.getPriceStr();
    }
    return prices;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    if (cartPro.postageResponseEntity == null) {
      return const SizedBox.shrink();
    }
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
          // No need to call setState, provider will notify
        }
      },
      child: ShadowContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${'postage'.tr()}:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                )),
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
                      if (!snapPrices.hasData) {
                        return const SizedBox.shrink();
                      }
                      final Map<String, String> prices = snapPrices.data!;
                      final List<Widget> items = <Widget>[];
                      // Show all products, not just those in selectedShippingItems
                      for (final PostageItemDetailEntity detail
                          in cartPro.postageResponseEntity!.detail.values) {
                        final String cartItemId = detail.cartItemId;
                        final String title = posts[detail.postId]?.title ??
                            'unknown_product'.tr();
                        final String? priceStr = prices[cartItemId];
                        final DeliveryType deliveryType =
                            detail.originalDeliveryType;
                        final bool isFree =
                            deliveryType == DeliveryType.freeDelivery;
                        final bool isFast =
                            deliveryType == DeliveryType.fastDelivery;
                        final bool isPaid = deliveryType == DeliveryType.paid;
                        final bool needsRates = isPaid || isFast;
                        if (priceStr != null) {
                          items.add(_row(title, priceStr, context));
                        } else if (needsRates) {
                          // Paid or fast delivery but no rates: show remove item message
                          items.add(_row(
                              title,
                              'remove_item_cart_continue_checkout'.tr(),
                              context,
                              italic: true,
                              color: Theme.of(context).colorScheme.error));
                        } else if (isFree && !isFast) {
                          // Free delivery and not fast: show free
                          items.add(
                              _row(title, 'free'.tr(), context, italic: true));
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ...items,
                        ],
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

  Widget _row(String title, String trailing, BuildContext context,
      {bool isBold = false, bool italic = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Text(trailing,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                    color: color,
                  )),
        ],
      ),
    );
  }
}
