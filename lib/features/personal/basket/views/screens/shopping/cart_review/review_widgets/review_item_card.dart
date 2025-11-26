import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../domain/entities/cart/added_shipping_response_entity.dart';
import '../../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../../providers/cart_provider.dart';

class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({required this.detail, this.shippingDetail, super.key});
  final CartItemEntity? detail;
  final AddShippingCartItemEntity? shippingDetail;

  @override
  Widget build(BuildContext context) {
    final String postId = detail?.postID ?? '';
    final dynamic cachedPost = LocalPost().post(postId);

    if (cachedPost != null) {
      final dynamic cachedSeller =
          LocalUser().userEntity(cachedPost?.createdBy ?? '');
      return _ReviewItemContent(
        post: cachedPost,
        seller: cachedSeller,
        detail: detail,
        shippingDetail: shippingDetail,
      );
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
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text('item_details_unavailable'.tr()),
          );
        }

        return FutureBuilder<dynamic>(
          future: LocalUser().user(fetchedPost?.createdBy ?? ''),
          builder: (BuildContext context, AsyncSnapshot<dynamic> userSnap) {
            final dynamic fetchedUser = userSnap.data;
            return _ReviewItemContent(
              post: fetchedPost,
              seller: fetchedUser,
              detail: detail,
              shippingDetail: shippingDetail,
            );
          },
        );
      },
    );
  }
}

class _ReviewItemContent extends StatelessWidget {
  const _ReviewItemContent({
    required this.post,
    required this.seller,
    required this.detail,
    required this.shippingDetail,
  });

  final PostEntity post;
  final dynamic seller;
  final CartItemEntity? detail;
  final AddShippingCartItemEntity? shippingDetail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? image = post.imageURL as String?;
    final String title = (post.title.trim().isNotEmpty)
        ? post.title
        : detail?.postID ?? 'Unknown';
    final int quantity = detail?.quantity ?? 1;

    final CartProvider cartPro = Provider.of<CartProvider>(context);
    final bool fastRequested = shippingDetail?.selectedShipping
            .any((SelectedShippingEntity s) => s.fastDelivery.requested) ??
        false;
    final bool showFastBadge =
        cartPro.fastDeliveryProducts.contains(detail?.postID ?? '') ||
            fastRequested;

    final SelectedShippingEntity? primaryShipping =
        (shippingDetail?.selectedShipping.isNotEmpty ?? false)
            ? shippingDetail!.selectedShipping.first
            : null;

    final int parcelCount = shippingDetail?.selectedShipping.length ?? 0;

    final String destination = _buildDestination(
      shipping: primaryShipping?.toAddress,
      address: cartPro.address,
    );

    final List<Widget> attributeChips = <Widget>[];

    if (detail?.size != null && detail!.size!.isNotEmpty) {
      attributeChips.add(_InfoPill('${'size'.tr()}: ${detail!.size}'));
    }

    if (detail?.color != null && detail!.color!.isNotEmpty) {
      int colorValue =
          int.tryParse(detail!.color!.replaceFirst('#', '0xff')) ?? 0xff000000;
      attributeChips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.08),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Color(colorValue),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'color'.tr(),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${'seller'.tr()}: ',
                        style: theme.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: (seller?.displayName ?? '').toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showFastBadge) const _FastDeliveryBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomNetworkImage(imageURL: image, size: 64),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (attributeChips.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: attributeChips,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<double?>(
            future: post.getLocalPrice(),
            builder: (BuildContext context, AsyncSnapshot<double?> snap) {
              if (!snap.hasData) {
                return const SizedBox(
                  height: 40,
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              final double unitPrice = snap.data ?? 0.0;
              final double nativeShipping =
                  primaryShipping?.nativeBufferAmount ?? 0.0;
              final double totalAmount = unitPrice * quantity + nativeShipping;

              return _PriceBreakdown(
                total:
                    '${CountryHelper.currencySymbolHelper(primaryShipping?.nativeCurrency)}${totalAmount.toStringAsFixed(2)}',
                unitPrice: unitPrice,
                quantity: quantity,
                shippingLabel:
                    '${CountryHelper.currencySymbolHelper(primaryShipping?.nativeCurrency)}${nativeShipping.toStringAsFixed(2)}${parcelCount > 1 ? ' ($parcelCount ${'parcels'.tr()})' : ''}',
              );
            },
          ),
          if (destination.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.location_on_outlined,
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'post_to'.tr(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(destination, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FastDeliveryBadge extends StatelessWidget {
  const _FastDeliveryBadge();

  @override
  Widget build(BuildContext context) {
    const DeliveryType del = DeliveryType.fastDelivery;
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: del.bgColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        del.code.tr(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: del.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({
    required this.total,
    required this.unitPrice,
    required this.quantity,
    this.shippingLabel,
  });

  final String? total;
  final double unitPrice;
  final int quantity;
  final String? shippingLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double subtotal = unitPrice * quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Subtotal with quantity
        Text(
          '${'subtotal'.tr()} ($quantity): ${CountryHelper.currencySymbolHelper(LocalAuth.currency)}${subtotal.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),

        // Shipping if available
        if (shippingLabel != null && shippingLabel!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '${'shipping'.tr()}: $shippingLabel',
            style: theme.textTheme.bodyMedium,
          ),
        ],

        const SizedBox(height: 8),
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${'total'.tr()}: $total',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: theme.textTheme.labelSmall),
    );
  }
}

String _buildDestination({AddressEntity? shipping, AddressEntity? address}) {
  List<String> shippingParts = _compactParts(<String?>[
    shipping?.address1,
    shipping?.city,
    shipping?.state?.stateName,
    shipping?.country.displayName,
    shipping?.postalCode
  ]);
  if (shippingParts.isNotEmpty) return shippingParts.join(', ');

  List<String> addressParts = _compactParts(<String?>[
    address?.address1,
    address?.city,
    address?.state?.stateName,
    address?.country.displayName,
    address?.postalCode
  ]);
  if (addressParts.isNotEmpty) return addressParts.join(', ');

  return '';
}

List<String> _compactParts(List<String?> values) => values
    .where((String? v) => v != null && v.trim().isNotEmpty)
    .map((String? v) => v!.trim())
    .toList();
