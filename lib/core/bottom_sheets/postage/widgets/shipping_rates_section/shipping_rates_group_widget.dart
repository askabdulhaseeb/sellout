import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../features/personal/basket/domain/param/submit_shipping_param.dart';
import '../../../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../../../features/postage/domain/entities/postage_detail_response_entity.dart';

import '../../../../constants/app_spacings.dart';
import '../../../../enums/shipping_provider_enum.dart';
import 'single_rate_tile.dart';

/// Widget displaying shipping rates grouped by provider
/// Allows selection of individual shipping options
class ShippingRatesGroupWidget extends StatefulWidget {
  const ShippingRatesGroupWidget({
    required this.rates,
    required this.cartItemId,
    super.key,
  });

  final List<RateEntity> rates;
  final String cartItemId;

  @override
  State<ShippingRatesGroupWidget> createState() =>
      _ShippingRatesGroupWidgetState();
}

class _ShippingRatesGroupWidgetState extends State<ShippingRatesGroupWidget> {
  late Map<String, List<RateEntity>> _groupedRates;
  final Set<String> _expandedProviders = <String>{};

  @override
  void initState() {
    super.initState();
    _groupedRates = _groupRatesByProvider();
    if (_groupedRates.isNotEmpty) {
      // Expand the first provider by default
      _expandedProviders.add(_groupedRates.keys.first);
    }
    _findAndSelectCheapestRate();
  }

  /// Groups rates by provider with enhanced logic
  Map<String, List<RateEntity>> _groupRatesByProvider() {
    final Map<String, List<RateEntity>> grouped = <String, List<RateEntity>>{};

    for (final RateEntity rate in widget.rates) {
      if (rate.objectId.isEmpty) continue;
      final String key = _getProviderKey(rate);
      grouped.putIfAbsent(key, () => <RateEntity>[]).add(rate);
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

  /// Gets a display key for grouping a rate by provider
  String _getProviderKey(RateEntity rate) {
    ShippingProvider providerEnum = getProviderEnum(rate.provider);

    if (providerEnum == ShippingProvider.sendcloud ||
        providerEnum == ShippingProvider.other) {
      final ShippingProvider fromCarrier = getProviderEnum(rate.carrierAccount);
      if (fromCarrier != ShippingProvider.other) {
        providerEnum = fromCarrier;
      } else {
        final ShippingProvider fromToken = getProviderEnum(
          rate.serviceLevel.token,
        );
        if (fromToken != ShippingProvider.other) {
          providerEnum = fromToken;
        }
      }
    }

    return providerDisplayNames[providerEnum] ?? 'Other';
  }

  /// Finds the cheapest rate and selects it
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
      final String cheapestKey = _getProviderKey(cheapest);
      setState(() {
        _expandedProviders.clear();
        _expandedProviders.add(cheapestKey);
      });

      final CartProvider cartPro = Provider.of<CartProvider>(
        context,
        listen: false,
      );
      cartPro.updateShippingSelection(widget.cartItemId, cheapest.objectId);
    }
  }

  void _toggleProvider(String provider) {
    setState(() {
      if (_expandedProviders.contains(provider)) {
        _expandedProviders.remove(provider);
      } else {
        _expandedProviders.clear();
        _expandedProviders.add(provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = Provider.of<CartProvider>(context);
    final ShippingItemParam? selectedItem = cartPro.selectedShippingItems
        .where(
          (ShippingItemParam item) =>
              item.cartItemId == widget.cartItemId && item.objectId.isNotEmpty,
        )
        .firstOrNull;

    final List<String> providers = _groupedRates.keys.toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: providers.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        final String provider = providers[index];
        final List<RateEntity> providerRates = _groupedRates[provider]!;
        final bool isExpanded = _expandedProviders.contains(provider);
        final String providerImage = providerRates.first.providerImage75;

        return _ProviderGroup(
          provider: provider,
          providerImage: providerImage,
          rates: providerRates,
          isExpanded: isExpanded,
          selectedRateId: selectedItem?.objectId,
          cartItemId: widget.cartItemId,
          onToggle: () => _toggleProvider(provider),
        );
      },
    );
  }
}

/// Provider group header and rates section
class _ProviderGroup extends StatelessWidget {
  const _ProviderGroup({
    required this.provider,
    required this.providerImage,
    required this.rates,
    required this.isExpanded,
    required this.selectedRateId,
    required this.cartItemId,
    required this.onToggle,
  });

  final String provider;
  final String providerImage;
  final List<RateEntity> rates;
  final bool isExpanded;
  final String? selectedRateId;
  final String cartItemId;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: providerImage.isNotEmpty
              ? Image.network(
                  providerImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                )
              : Icon(
                  Icons.local_shipping,
                  color: Theme.of(context).primaryColor,
                ),
          title: Text(
            provider,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          onTap: onToggle,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < rates.length; i++) ...<Widget>[
                  SingleRateTile(
                    rate: rates[i],
                    isSelected: rates[i].objectId == selectedRateId,
                    cartItemId: cartItemId,
                  ),
                  if (i < rates.length - 1)
                    const Divider(height: 1, indent: 0, endIndent: 0),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
