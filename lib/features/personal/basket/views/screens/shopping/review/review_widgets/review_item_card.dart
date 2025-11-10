import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../auth/signin/data/models/address_model.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../domain/entities/cart/add_shipping_response_entity.dart';
import '../../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../../providers/cart_provider.dart';

class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({required this.detail, this.shippingDetail, super.key});
  final CartItemEntity detail;
  final AddShippingCartItemEntity? shippingDetail;

  @override
  Widget build(BuildContext context) {
    final String postId = detail.postID;

    // Try to render cached post & seller immediately if available
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
          // Post not available
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

  final dynamic post;
  final dynamic seller;
  final CartItemEntity detail;
  final AddShippingCartItemEntity? shippingDetail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? image = post?.imageURL as String?;
    final String title = (() {
      final dynamic raw = post?.title;
      if (raw is String && raw.trim().isNotEmpty) {
        return raw;
      }
      return detail.postID;
    })();
    final double unitPrice = (post?.price ?? 0) is num
        ? (post?.price ?? 0).toDouble()
        : double.tryParse((post?.price ?? '0').toString()) ?? 0.0;
    final int quantity = detail.quantity;
    final double subtotal = unitPrice * quantity;

    final CartProvider cartPro = Provider.of<CartProvider>(context);
    final bool fastRequested = shippingDetail?.selectedShipping.any(
            (SelectedShippingEntity s) => s.fastDelivery?.requested ?? false) ??
        false;
    final bool showFastBadge =
        cartPro.fastDeliveryProducts.contains(detail.postID) || fastRequested;

    final SelectedShippingEntity? primaryShipping =
        (shippingDetail?.selectedShipping.isNotEmpty ?? false)
            ? shippingDetail!.selectedShipping.first
            : null;

    final String currencyCode = (post?.currency ?? '').toString();
    final String unitPriceLabel = _formatAmount(unitPrice, currencyCode);
    final String subtotalLabel = _formatAmount(subtotal, currencyCode);

    double totalPrice = subtotal;
    String totalCurrency = currencyCode;
    String? shippingLabel;
    final double? shippingAmount = primaryShipping?.convertedBufferAmount;
    final String? shippingCurrency = primaryShipping?.convertedCurrency;

    if (shippingAmount != null && shippingAmount > 0) {
      shippingLabel =
          _formatAmount(shippingAmount, shippingCurrency ?? currencyCode);
      if (shippingCurrency != null &&
          shippingCurrency.isNotEmpty &&
          shippingCurrency == currencyCode) {
        totalPrice += shippingAmount;
      }
      if (shippingCurrency != null && shippingCurrency.isNotEmpty) {
        totalCurrency = shippingCurrency;
      }
    }

    final String totalLabel = _formatAmount(totalPrice, totalCurrency);
    final String destination = _buildDestination(
      shipping: primaryShipping?.toAddress,
      address: cartPro.address,
    );

    final List<Widget> attributeChips = <Widget>[];
    final String? conditionCode = post?.condition?.code as String?;
    if (conditionCode != null && conditionCode.isNotEmpty) {
      attributeChips.add(_InfoPill(conditionCode));
    }
    if (detail.size != null && detail.size!.isNotEmpty) {
      attributeChips.add(_InfoPill('${'size'.tr()}: ${detail.size}'));
    }
    if (detail.color != null && detail.color!.isNotEmpty) {
      attributeChips.add(_InfoPill('${'color'.tr()}: ${detail.color}'));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline,
        ),
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
              if (showFastBadge) ...<Widget>[
                const _FastDeliveryBadge(),
                const SizedBox(width: 8),
              ],
              _QuantityChip(quantity: quantity),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(imageURL: image, size: 78),
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
              const SizedBox(width: 12),
              _PriceBreakdown(
                unitPriceLabel: unitPriceLabel,
                quantity: quantity,
                subtotalLabel: subtotalLabel,
                totalLabel: totalLabel,
                shippingLabel: shippingLabel,
              ),
            ],
          ),
          if (destination.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.location_on_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
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
                      Text(
                        destination,
                        style: theme.textTheme.bodyMedium,
                      ),
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
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'fast_delivery'.tr(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QuantityChip extends StatelessWidget {
  const _QuantityChip({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${'quantity'.tr()}: $quantity',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({
    required this.unitPriceLabel,
    required this.quantity,
    required this.subtotalLabel,
    required this.totalLabel,
    this.shippingLabel,
  });

  final String unitPriceLabel;
  final int quantity;
  final String subtotalLabel;
  final String totalLabel;
  final String? shippingLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          '$unitPriceLabel × $quantity',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (shippingLabel != null && shippingLabel!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${'shipping'.tr()}: $shippingLabel',
              style: theme.textTheme.bodySmall,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${'subtotal'.tr()}: $subtotalLabel',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${'total'.tr()}: $totalLabel',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
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
      child: Text(
        text,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}

String _buildDestination({
  ShippingAddressEntity? shipping,
  AddressEntity? address,
}) {
  final List<String> shippingParts = _compactParts(<String?>[
    shipping?.address1 ?? shipping?.street1,
    shipping?.city,
    shipping?.state,
    shipping?.country,
    shipping?.postalCode ?? shipping?.zip,
  ]);
  if (shippingParts.isNotEmpty) {
    return shippingParts.join(', ');
  }

  final List<String> addressParts = _compactParts(<String?>[
    address?.address,
    address?.city,
    address?.state.stateName,
    address?.country.displayName,
    address?.postalCode,
  ]);
  if (addressParts.isNotEmpty) {
    return addressParts.join(', ');
  }

  return '';
}

List<String> _compactParts(List<String?> values) => values
    .where((String? value) => value != null && value.trim().isNotEmpty)
    .map((String? value) => value!.trim())
    .toList();
String _formatAmount(double? amount, String? currency) {
  if (amount == null) return '';
  final String symbol =
      currency != null && currency.isNotEmpty ? currency.toUpperCase() : '';
  return symbol.isEmpty
      ? amount.toStringAsFixed(2)
      : '$symbol ${amount.toStringAsFixed(2)}';
}
