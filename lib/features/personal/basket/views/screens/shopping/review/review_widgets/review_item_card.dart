import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/entities/cart/add_shipping_response_entity.dart';
import '../../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../../../domain/entities/cart/postage_detail_response_entity.dart';
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

        if (shippingDetail != null &&
            shippingDetail!.selectedShipping.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _ShippingDetailsSection(
              selected: shippingDetail!.selectedShipping,
            ),
          ),
      ],
    );
  }
}

class _ShippingDetailsSection extends StatelessWidget {
  const _ShippingDetailsSection({required this.selected});

  final List<SelectedShippingEntity> selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Shipping Details',
          style:
              theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...selected
            .map((SelectedShippingEntity detail) =>
                _ShippingDetailCard(detail: detail))
            .toList(),
      ],
    );
  }
}

class _ShippingDetailCard extends StatelessWidget {
  const _ShippingDetailCard({required this.detail});

  final SelectedShippingEntity detail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> infoRows = <Widget>[
      _InfoRow(label: 'Delivery Type', value: _titleCase(detail.deliveryType)),
      if (detail.serviceName != null && detail.serviceName!.isNotEmpty)
        _InfoRow(label: 'Service', value: detail.serviceName),
      if (detail.provider != null && detail.provider!.isNotEmpty)
        _InfoRow(label: 'Provider', value: detail.provider),
      if (detail.rateObjectId != null && detail.rateObjectId!.isNotEmpty)
        _InfoRow(label: 'Rate ID', value: detail.rateObjectId),
      if (detail.shipmentId != null && detail.shipmentId!.isNotEmpty)
        _InfoRow(label: 'Shipment ID', value: detail.shipmentId),
      if (_formatAmount(detail.convertedBufferAmount, detail.convertedCurrency)
          .isNotEmpty)
        _InfoRow(
          label: 'Total Cost',
          value: _formatAmount(
              detail.convertedBufferAmount, detail.convertedCurrency),
        ),
      if (_formatAmount(detail.nativeBufferAmount, detail.nativeCurrency)
          .isNotEmpty)
        _InfoRow(
          label: 'Native Cost',
          value:
              _formatAmount(detail.nativeBufferAmount, detail.nativeCurrency),
        ),
      if (_formatAmount(detail.coreAmount, detail.nativeCurrency).isNotEmpty)
        _InfoRow(
          label: 'Core Amount',
          value: _formatAmount(detail.coreAmount, detail.nativeCurrency),
        ),
      if (detail.note != null && detail.note!.isNotEmpty)
        _InfoRow(label: 'Note', value: detail.note),
    ];

    final List<Widget> chips = <Widget>[];
    if (detail.packagingStrategy != null &&
        detail.packagingStrategy!.isNotEmpty) {
      chips.add(_ChipLabel('Strategy: ${detail.packagingStrategy}'));
    }
    if (detail.parcelCount != null) {
      chips.add(_ChipLabel('Parcels: ${detail.parcelCount}'));
    }
    if (detail.fastDelivery != null) {
      chips.add(_ChipLabel(
          'Fast Delivery: ${detail.fastDelivery!.available ? 'Available' : 'Not Available'}'));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...infoRows
              .where((Widget row) => row is _InfoRow ? (row).hasValue : true),
          if (detail.parcel != null) ...<Widget>[
            const SizedBox(height: 8),
            _ParcelSummary(parcel: detail.parcel!),
          ],
          if (detail.fromAddress != null ||
              detail.toAddress != null) ...<Widget>[
            const SizedBox(height: 8),
            if (detail.fromAddress != null)
              _InfoRow(
                  label: 'From',
                  value:
                      '${detail.fromAddress?.address1}, ${detail.fromAddress?.city}, ${detail.fromAddress?.country}'),
            if (detail.toAddress != null)
              _InfoRow(
                label: 'To',
                value:
                    '${detail.toAddress?.address1}, ${detail.toAddress?.city}, ${detail.toAddress?.country}',
              ),
          ],
          if (chips.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 4, children: chips),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required String? value})
      : _value = value;

  final String label;
  final String? _value;

  bool get hasValue => _value != null && _value.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!hasValue) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall,
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: theme.textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: _value),
          ],
        ),
      ),
    );
  }
}

class _ParcelSummary extends StatelessWidget {
  const _ParcelSummary({required this.parcel});

  final SelectedShippingParcelEntity parcel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> metrics = <String>[];
    if (parcel.length != null && parcel.length!.isNotEmpty) {
      metrics.add('L: ${parcel.length}');
    }
    if (parcel.width != null && parcel.width!.isNotEmpty) {
      metrics.add('W: ${parcel.width}');
    }
    if (parcel.height != null && parcel.height!.isNotEmpty) {
      metrics.add('H: ${parcel.height}');
    }
    if (parcel.distanceUnit != null && parcel.distanceUnit!.isNotEmpty) {
      metrics.add(parcel.distanceUnit!);
    }
    if (parcel.weight != null && parcel.weight!.isNotEmpty) {
      metrics.add('Weight: ${parcel.weight}');
    }
    if (parcel.massUnit != null && parcel.massUnit!.isNotEmpty) {
      metrics.add(parcel.massUnit!);
    }

    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        metrics.join(' · '),
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: theme.textTheme.labelSmall),
    );
  }
}

String _formatAmount(double? amount, String? currency) {
  if (amount == null) return '';
  final String symbol =
      currency != null && currency.isNotEmpty ? currency.toUpperCase() : '';
  return symbol.isEmpty
      ? amount.toStringAsFixed(2)
      : '$symbol ${amount.toStringAsFixed(2)}';
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value
      .split(RegExp(r'[\s_]'))
      .where((String word) => word.isNotEmpty)
      .map((String word) =>
          word[0].toUpperCase() +
          (word.length > 1 ? word.substring(1).toLowerCase() : ''))
      .join(' ');
}
