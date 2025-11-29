import 'package:flutter/material.dart';
import '../../../../features/personal/basket/domain/param/submit_shipping_param.dart';
import '../../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../features/personal/post/data/sources/local/local_post.dart';
import '../../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../enums/listing/core/delivery_type.dart';
import '../../../constants/app_spacings.dart';
import 'package:provider/provider.dart';
import '../../../widgets/shadow_container.dart';

class PostageItemCard extends StatefulWidget {
  const PostageItemCard({
    required this.cartItemId,
    required this.detail,
    super.key,
  });
  final String cartItemId;
  final PostageItemDetailEntity detail;

  @override
  State<PostageItemCard> createState() => _PostageItemCardState();
}

class _PostageItemCardState extends State<PostageItemCard> {
  @override
  Widget build(BuildContext context) {
    // Hide collection items
    final DeliveryType deliveryType = widget.detail.originalDeliveryType;
    if (deliveryType == DeliveryType.collection) {
      return const SizedBox.shrink();
    }
    if (deliveryType == DeliveryType.freeDelivery &&
        widget.detail.fastDelivery.requested == false) {
      return ShadowContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Icon(Icons.check_circle_outline,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'free'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          const SizedBox(height: AppSpacing.md),
          _buildShippingOptions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final List<RateEntity> rates = _getAllRates();
    final DeliveryType deliveryType = widget.detail.originalDeliveryType;

    final bool hasRates = rates.isNotEmpty;
    final bool isFree = deliveryType == DeliveryType.freeDelivery;
    final bool isFast = deliveryType == DeliveryType.fastDelivery;
    final PostEntity? post = LocalPost().post(widget.detail.postId);
    final String badgeText = isFast
        ? 'fast_delivery'.tr()
        : isFree
            ? 'free_delivery'.tr()
            : hasRates
                ? 'delivery_available'.tr()
                : 'delivery_unavailable'.tr();

    final Color badgeColor = (isFast || isFree || hasRates)
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;

    return Row(
      children: <Widget>[
        Icon(Icons.local_shipping,
            color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            post?.title ?? 'na'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingOptions(BuildContext context) {
    final List<RateEntity> rates = _getAllRates();
    final DeliveryType deliveryType = widget.detail.originalDeliveryType;
    final bool isFree = deliveryType == DeliveryType.freeDelivery;
    final bool isFast = deliveryType == DeliveryType.fastDelivery;
    final bool isPaid = deliveryType == DeliveryType.paid;
    final bool needsRates = isPaid || isFast;

    if (rates.isNotEmpty) {
      final CartProvider cartPro = Provider.of<CartProvider>(context);
      ShippingItemParam? selectedItem =
          cartPro.selectedShippingItems.firstWhere(
        (ShippingItemParam item) =>
            item.cartItemId == widget.cartItemId && item.objectId.isNotEmpty,
        orElse: () => ShippingItemParam(cartItemId: '', objectId: ''),
      );
      String selectedObjectId = selectedItem.objectId;

      // If no selection exists for this cartItemId, auto-select the first rate
      if (selectedObjectId.isEmpty && rates.isNotEmpty) {
        selectedObjectId = rates.first.objectId;
        // Update provider so state is consistent
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cartPro.updateShippingSelection(widget.cartItemId, selectedObjectId);
        });
      }

      return SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          cacheExtent: 5000,
          itemCount: rates.length,
          itemBuilder: (BuildContext context, int index) {
            final RateEntity rate = rates[index];
            return _buildRateOption(context, rate, selectedObjectId, cartPro);
          },
        ),
      );
    } else if (needsRates) {
      // Paid or fast delivery but no rates: show remove item message
      return _buildNoRatesMessage(context);
    } else if (isFree && !isFast) {
      // Free delivery and not fast: show free
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Icon(Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'free'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildRateOption(BuildContext context, RateEntity rate,
      String selectedObjectId, CartProvider cartPro) {
    void select() {
      cartPro.updateShippingSelection(widget.cartItemId, rate.objectId);
    }

    return ListTile(
      leading: Radio<String>(
        value: rate.objectId,
        groupValue: selectedObjectId,
        onChanged: (_) => select(),
      ),
      title: Text(
        '${rate.provider} · ${rate.serviceLevel.name}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: FutureBuilder<String>(
        future: rate.getPriceStr(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) => Text(
          snapshot.data ?? '...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      onTap: select,
    );
  }

  // Removed legacy _buildRateOption with onSelect reference and duplicate signature.
  Widget _buildNoRatesMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'remove_item_cart_continue_checkout'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  List<RateEntity> _getAllRates() {
    final CartProvider cartPro = Provider.of<CartProvider>(context);
    final PostageItemDetailEntity? detail =
        cartPro.postageResponseEntity?.detail[widget.cartItemId];
    if (detail == null) return <RateEntity>[];
    return detail.shippingDetails
        .expand<RateEntity>(
            (PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
        .toList();
  }
}
