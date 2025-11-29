import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../providers/cart_provider.dart';

class SimplePostageSection extends StatefulWidget {
  const SimplePostageSection({super.key});

  @override
  State<SimplePostageSection> createState() => SimplePostageSectionState();
}

class SimplePostageSectionState extends State<SimplePostageSection> {
  // Fetch posts from local storage
  Future<Map<String, PostEntity?>> _getPosts() async {
    await LocalPost.openBox;
    final CartProvider cartPro = context.read<CartProvider>();
    final Map<String, PostEntity?> posts = <String, PostEntity?>{};
    for (final String id in cartPro.postageResponseEntity!.detail.keys) {
      posts[id] = await LocalPost().getPost(id, silentUpdate: true);
    }
    return posts;
  }

  // Fetch converted price strings asynchronously
  Future<Map<String, String>> _getConvertedPrices(CartProvider cartPro) async {
    final Map<String, String> prices = <String, String>{};
    for (final MapEntry<String, PostageItemDetailEntity> entry
        in cartPro.postageResponseEntity!.detail.entries) {
      final String postId = entry.key;
      final RateEntity? rate = cartPro.selectedPostageRates[postId];
      if (rate != null) {
        prices[postId] = await rate.getPriceStr(); // await async price
      }
    }
    return prices;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, CartProvider cartPro, __) {
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
              // Rebuild after selecting postage rates
              setState(() {});
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
                    future: _getPosts(),
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
                          for (final MapEntry<String,
                                  PostageItemDetailEntity> entry
                              in cartPro
                                  .postageResponseEntity!.detail.entries) {
                            final String postId = entry.key;
                            final PostageItemDetailEntity detail = entry.value;
                            final String title =
                                posts[postId]?.title ?? 'unknown_product'.tr();

                            final String? priceStr = prices[postId];
                            if (priceStr != null) {
                              items.add(_row(title, priceStr, context));
                            } else {
                              final bool isFree = detail.originalDeliveryType
                                  .toLowerCase()
                                  .contains('free');
                              items.add(_row(
                                  title,
                                  isFree ? 'free'.tr() : 'tap_to_select'.tr(),
                                  context,
                                  italic: true));
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
      },
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
