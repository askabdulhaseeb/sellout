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
      content = _ErrorMessage(cartItemId: cartItemId);
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

// ======= Shipping Options Grouped by Provider =======
class _RateList extends StatefulWidget {
  const _RateList({required this.rates, required this.cartItemId});
  final List<RateEntity> rates;
  final String cartItemId;

  @override
  State<_RateList> createState() => _RateListState();
}

class _RateListState extends State<_RateList> {
  // Track which providers are expanded
  final Set<String> _expandedProviders = <String>{};
  bool _cheapestRateCalculated = false;

  @override
  void initState() {
    super.initState();
    // Expand the first provider by default
    if (widget.rates.isNotEmpty) {
      _expandedProviders.add(widget.rates.first.provider);
    }
    // Calculate and select cheapest rate on init
    _findAndSelectCheapestRate();
  }

  /// Finds the cheapest rate across all providers and selects it
  Future<void> _findAndSelectCheapestRate() async {
    if (widget.rates.isEmpty) return;

    RateEntity? cheapest;
    double? lowestPrice;

    for (final RateEntity rate in widget.rates) {
      final double? price = await rate.getLocalPrice();
      if (price != null && (lowestPrice == null || price < lowestPrice)) {
        lowestPrice = price;
        cheapest = rate;
      }
    }

    if (cheapest != null && mounted) {
      setState(() {
        _cheapestRateCalculated = true;
        // Expand the provider that has the cheapest rate
        _expandedProviders.clear();
        _expandedProviders.add(cheapest!.provider);
      });

      // Update selection to cheapest rate
      final CartProvider cartPro = Provider.of<CartProvider>(
        context,
        listen: false,
      );
      cartPro.updateShippingSelection(widget.cartItemId, cheapest.objectId);
    }
  }

  /// Groups rates by provider (e.g., "DPD UK", "Royal Mail", etc.)
  Map<String, List<RateEntity>> _groupRatesByProvider() {
    final Map<String, List<RateEntity>> grouped = <String, List<RateEntity>>{};
    for (final RateEntity rate in widget.rates) {
      grouped
          .putIfAbsent(rate.serviceLevel.token, () => <RateEntity>[])
          .add(rate);
    }
    // Sort each provider's rates by price (cheapest first)
    for (final List<RateEntity> rates in grouped.values) {
      rates.sort((RateEntity a, RateEntity b) {
        final double priceA = double.tryParse(a.amountBuffered) ?? 0;
        final double priceB = double.tryParse(b.amountBuffered) ?? 0;
        return priceA.compareTo(priceB);
      });
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = Provider.of<CartProvider>(context);
    final ShippingItemParam selectedItem = cartPro.selectedShippingItems
        .where(
          (ShippingItemParam item) =>
              item.cartItemId == widget.cartItemId && item.objectId.isNotEmpty,
        )
        .first;

    String selectedId = selectedItem.objectId;
    // Only use first rate as fallback if cheapest rate hasn't been calculated yet
    if (selectedId.isEmpty &&
        widget.rates.isNotEmpty &&
        !_cheapestRateCalculated) {
      selectedId = widget.rates.first.objectId;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => cartPro.updateShippingSelection(widget.cartItemId, selectedId),
      );
    }

    final Map<String, List<RateEntity>> groupedRates = _groupRatesByProvider();
    final List<String> providers = groupedRates.keys.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: providers.length,
      itemBuilder: (_, int providerIndex) {
        final String provider = providers[providerIndex];
        final List<RateEntity> providerRates = groupedRates[provider]!;
        final bool isExpanded = _expandedProviders.contains(provider);
        final String providerImage = providerRates.first.providerImage75;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Provider Header (expandable)
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedProviders.remove(provider);
                  } else {
                    _expandedProviders.add(provider);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: <Widget>[
                    if (providerImage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: Image.network(
                          providerImage,
                          width: 32,
                          height: 32,
                          errorBuilder:
                              (BuildContext _, Object e, StackTrace? s) =>
                                  const Icon(Icons.local_shipping, size: 32),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(right: AppSpacing.sm),
                        child: Icon(Icons.local_shipping, size: 32),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            provider,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${providerRates.length} ${'services'.tr()}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            // Service options (collapsible)
            if (isExpanded)
              ...providerRates.map((RateEntity rate) {
                final bool isSelected = selectedId == rate.objectId;
                return InkWell(
                  onTap: () => cartPro.updateShippingSelection(
                    widget.cartItemId,
                    rate.objectId,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      children: <Widget>[
                        // Selection indicator
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              width: 2,
                            ),
                            color: isSelected
                                ? Theme.of(context).colorScheme.error
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // Service name
                        Expanded(
                          child: Text(
                            rate.serviceLevel.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.error
                                      : null,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                        ),
                        // Price
                        FutureBuilder<String>(
                          future: rate.getPriceStr(),
                          builder: (_, AsyncSnapshot<String> snapshot) => Text(
                            snapshot.data ?? '...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.error
                                      : null,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            if (providerIndex < providers.length - 1) const Divider(height: 1),
          ],
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
          Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'free'.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
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
