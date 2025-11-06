import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../providers/cart_provider.dart';

class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({required this.detail, super.key});
  final CartItemEntity detail;

  @override
  Widget build(BuildContext context) {
    final String postId = detail.postID;

    // Try to render cached post & seller immediately if available
    final dynamic cachedPost = LocalPost().post(postId);
    if (cachedPost != null) {
      final dynamic cachedSeller =
          LocalUser().userEntity(cachedPost?.createdBy ?? '');
      return _ReviewItemContent(
          post: cachedPost, seller: cachedSeller, detail: detail);
    }

    // Otherwise fetch post, then seller
    return FutureBuilder<dynamic>(
      future: LocalPost().getPost(postId, silentUpdate: true),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 96,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final dynamic fetchedPost = snap.data;
        if (fetchedPost == null) {
          // Post not available
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('item_details_unavailable'.tr()),
            ),
          );
        }

        return FutureBuilder<dynamic>(
          future: LocalUser().user(fetchedPost?.createdBy ?? ''),
          builder: (BuildContext context, AsyncSnapshot<dynamic> userSnap) {
            final dynamic fetchedUser = userSnap.data;
            return _ReviewItemContent(
                post: fetchedPost, seller: fetchedUser, detail: detail);
          },
        );
      },
    );
  }
}

class _ReviewItemContent extends StatelessWidget {
  const _ReviewItemContent(
      {required this.post, required this.seller, required this.detail});

  final dynamic post;
  final dynamic seller;
  final CartItemEntity detail;

  @override
  Widget build(BuildContext context) {
    final String? image = post?.imageURL as String?;
    final String title = post?.title ?? detail.postID ?? '';
    final double unitPrice = (post?.price ?? 0) is num
        ? (post?.price ?? 0).toDouble()
        : double.tryParse((post?.price ?? '0').toString()) ?? 0.0;
    final double totalPrice = (detail.quantity * unitPrice).toDouble();

    final CartProvider cartPro = Provider.of<CartProvider>(context);
    final bool selectedFast =
        cartPro.fastDeliveryProducts.contains(detail.postID);
    final PostageItemDetailEntity? postageDetail =
        cartPro.postageResponseEntity?.detail[detail.postID];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Seller row (mimics PersonalCartTile)
        Row(
          children: <Widget>[
            Expanded(
              child: Text.rich(
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '${'seller'.tr()}: ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: seller?.displayName ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
            ),
            if (selectedFast ||
                (postageDetail?.fastDelivery.requested ?? false))
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('fast_delivery'.tr(),
                    style: Theme.of(context).textTheme.labelSmall),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Product row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomNetworkImage(imageURL: image, size: 72),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(children: <Widget>[
                    if (post?.condition?.code != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(post?.condition?.code ?? '',
                            style: Theme.of(context).textTheme.labelSmall),
                      ),
                    const SizedBox(width: 8),
                    Text('${(totalPrice).toStringAsFixed(0)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 8),
                  // Size & color
                  Row(children: <Widget>[
                    if (detail.size != null)
                      Text('${'size'.tr()}: ${detail.size}',
                          style: Theme.of(context).textTheme.bodySmall),
                    if (detail.color != null)
                      Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: detail.color!.isNotEmpty
                                  ? Color(0xFF000000)
                                  : Colors.transparent,
                              shape: BoxShape.circle)),
                  ]),
                  const SizedBox(height: 8),
                  // Quantity
                  Text('${'quantity'.tr()}: ${detail.quantity}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Postage chips (item count / parcels)
        if (postageDetail != null)
          Wrap(spacing: 8, children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('${'items'.tr()}: ${postageDetail.itemCount}',
                  style: Theme.of(context).textTheme.labelSmall),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('${'parcels'.tr()}: ${postageDetail.parcelCount}',
                  style: Theme.of(context).textTheme.labelSmall),
            ),
          ]),
      ],
    );
  }
}
