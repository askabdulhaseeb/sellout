import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../../features/personal/post/data/sources/local/local_post.dart';
import '../../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../../features/postage/domain/entities/postage_detail_response_entity.dart';
import '../../../enums/listing/core/delivery_type.dart';
import '../../../constants/app_spacings.dart';
import '../../../widgets/text_display/shadow_container.dart';
import 'shipping_rates_section/shipping_rates_group_widget.dart';
import 'shipping_rates_section/shipping_state_widgets.dart';

class PostageItemCard extends StatelessWidget {
  const PostageItemCard({
    required this.cartItemId,
    required this.detail,
    super.key,
  });

  final String cartItemId;
  final PostageItemDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final DeliveryType deliveryType = detail.originalDeliveryType;

    // Hide collection items
    if (deliveryType == DeliveryType.collection) return const SizedBox.shrink();

    final bool isFree = deliveryType == DeliveryType.freeDelivery;
    final bool isFast = detail.fastDelivery.requested == true;
    final bool isPaid = deliveryType == DeliveryType.paid;
    final List<RateEntity> rates = _getAllRates(context);

    // Determine what to show
    Widget content;
    if ((isPaid || isFast) && rates.isEmpty) {
      content = _ErrorMessage(cartItemId: cartItemId);
    } else if (isFree && !isFast) {
      content = const FreeDeliveryWidget();
    } else if (rates.isNotEmpty) {
      content = ShippingRatesGroupWidget(rates: rates, cartItemId: cartItemId);
    } else {
      content = NoShippingOptionsWidget(cartItemId: cartItemId);
    }

    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PostageHeader(detail: detail, rates: rates),
          const SizedBox(height: AppSpacing.md),
          content,
        ],
      ),
    );
  }

  List<RateEntity> _getAllRates(BuildContext context) {
    final CartProvider cartPro = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    final PostageItemDetailEntity? detailFromResponse = cartPro
        .postageResponseEntity
        ?.detail
        .where((PostageItemDetailEntity d) => d.cartItemId == cartItemId)
        .first;
    if (detailFromResponse == null) return <RateEntity>[];
    return detailFromResponse.shippingDetails
        .expand(
          (PostageDetailShippingDetailEntity d) =>
              d.ratesBuffered.where((RateEntity r) => r.objectId.isNotEmpty),
        )
        .toList();
  }
}

// ======= Header =======
class _PostageHeader extends StatelessWidget {
  const _PostageHeader({required this.detail, required this.rates});
  final PostageItemDetailEntity detail;
  final List<RateEntity> rates;

  @override
  Widget build(BuildContext context) {
    final DeliveryType deliveryType = detail.originalDeliveryType;
    final PostEntity? post = LocalPost().post(detail.postId);

    final bool isFree = deliveryType == DeliveryType.freeDelivery;
    final bool isFast = detail.fastDelivery.requested == true;

    final bool hasRates = rates.isNotEmpty;

    final String badge = isFast
        ? 'fast_delivery'.tr()
        : isFree
        ? 'free_delivery'.tr()
        : hasRates
        ? 'delivery_available'.tr()
        : 'delivery_unavailable'.tr();

    final Color badgeColor = isFast
        ? DeliveryType.fastDelivery.color
        : isFree && !hasRates
        ? deliveryType.color
        : hasRates && !isFree
        ? deliveryType.color
        : Theme.of(context).colorScheme.error;

    return Row(
      children: <Widget>[
        Icon(
          Icons.local_shipping,
          color: Theme.of(context).colorScheme.onSurface,
        ),
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
            badge,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorMessage extends StatefulWidget {
  const _ErrorMessage({required this.cartItemId});
  final String cartItemId;

  @override
  State<_ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<_ErrorMessage> {
  bool _isRemoving = false;

  Future<void> _removeItem() async {
    setState(() => _isRemoving = true);
    try {
      final CartProvider cartPro = Provider.of<CartProvider>(
        context,
        listen: false,
      );
      await cartPro.removeItem(widget.cartItemId);
      if (mounted) {
        // Refresh rates after removing
        await cartPro.getRates();
      }
    } finally {
      if (mounted) {
        setState(() => _isRemoving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'remove_item_cart_continue_checkout'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: _isRemoving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton.icon(
                    onPressed: _removeItem,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text('remove_item'.tr()),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
