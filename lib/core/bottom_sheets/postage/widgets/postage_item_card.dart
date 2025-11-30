import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../features/personal/basket/domain/param/submit_shipping_param.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../../features/personal/post/data/sources/local/local_post.dart';
import '../../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../../features/postage/domain/entities/postage_detail_response_entity.dart';
import '../../../enums/listing/core/delivery_type.dart';
import '../../../constants/app_spacings.dart';
import '../../../widgets/shadow_container.dart';

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
      content = _ErrorMessage();
    } else if (isFree && !isFast) {
      content = _FreeText();
    } else {
      content = rates.isNotEmpty
          ? _RateList(rates: rates, cartItemId: cartItemId)
          : const SizedBox.shrink();
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
    final CartProvider cartPro =
        Provider.of<CartProvider>(context, listen: false);
    final PostageItemDetailEntity? detailFromResponse =
        cartPro.postageResponseEntity?.detail
            .where(
              (PostageItemDetailEntity d) => d.cartItemId == cartItemId,
            )
            .first;
    if (detailFromResponse == null) return <RateEntity>[];
    return detailFromResponse.shippingDetails
        .expand((PostageDetailShippingDetailEntity d) =>
            d.ratesBuffered.where((RateEntity r) => r.objectId.isNotEmpty))
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
        Icon(Icons.local_shipping,
            color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(post?.title ?? 'na'.tr(),
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
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

// ======= Shipping Options =======
class _RateList extends StatelessWidget {
  const _RateList({required this.rates, required this.cartItemId});
  final List<RateEntity> rates;
  final String cartItemId;

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = Provider.of<CartProvider>(context);
    ShippingItemParam selectedItem = cartPro.selectedShippingItems
        .where(
          (ShippingItemParam item) =>
              item.cartItemId == cartItemId && item.objectId.isNotEmpty,
        )
        .first;

    String selectedId = selectedItem.objectId;
    if (selectedId.isEmpty && rates.isNotEmpty) {
      selectedId = rates.first.objectId;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => cartPro.updateShippingSelection(cartItemId, selectedId),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rates.length,
      itemBuilder: (_, int i) {
        final RateEntity rate = rates[i];
        return ListTile(
          leading: Radio<String>(
            value: rate.objectId,
            groupValue: selectedId,
            onChanged: (_) =>
                cartPro.updateShippingSelection(cartItemId, rate.objectId),
          ),
          title: Text('${rate.provider} · ${rate.serviceLevel.name}',
              style: Theme.of(context).textTheme.bodyMedium),
          trailing: FutureBuilder<String>(
            future: rate.getPriceStr(),
            builder: (_, AsyncSnapshot<String> snapshot) => Text(
                snapshot.data ?? '...',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          onTap: () =>
              cartPro.updateShippingSelection(cartItemId, rate.objectId),
        );
      },
    );
  }
}

class _FreeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          Icon(Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text('free'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              child: Text('remove_item_cart_continue_checkout'.tr(),
                  style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
