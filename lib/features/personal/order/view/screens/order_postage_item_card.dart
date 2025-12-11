import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/enums/shipping_provider_enum.dart';
import '../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../personal/post/data/sources/local/local_post.dart';
import '../../../../personal/post/domain/entities/post/post_entity.dart';
import '../../../../../core/constants/app_spacings.dart';
import '../../../../../core/widgets/shadow_container.dart';

class OrderPostageItemCard extends StatefulWidget {
  const OrderPostageItemCard({
    required this.detail,
    required this.selectedRateId,
    required this.onRateSelected,
    super.key,
  });

  final PostageItemDetailEntity detail;
  final String? selectedRateId;
  final void Function(RateEntity rate) onRateSelected;

  @override
  State<OrderPostageItemCard> createState() => _OrderPostageItemCardState();
}

class _OrderPostageItemCardState extends State<OrderPostageItemCard> {
  final Set<String> _expandedProviders = <String>{};
  bool _cheapestRateCalculated = false;

  @override
  void initState() {
    super.initState();
    final List<RateEntity> rates = _getAllRates();
    if (rates.isNotEmpty) {
      _expandedProviders.add(rates.first.provider);
    }
    _findAndSelectCheapestRate();
  }

  List<RateEntity> _getAllRates() {
    return widget.detail.shippingDetails
        .expand(
          (PostageDetailShippingDetailEntity d) =>
              d.ratesBuffered.where((RateEntity r) => r.objectId.isNotEmpty),
        )
        .toList();
  }

  Future<void> _findAndSelectCheapestRate() async {
    final List<RateEntity> rates = _getAllRates();
    if (rates.isEmpty) return;

    RateEntity? cheapest;
    double? lowestPrice;

    for (final RateEntity rate in rates) {
      final double? price = await rate.getLocalPrice();
      if (price != null && (lowestPrice == null || price < lowestPrice)) {
        lowestPrice = price;
        cheapest = rate;
      }
    }

    if (cheapest != null && mounted) {
      setState(() {
        _cheapestRateCalculated = true;
        _expandedProviders.clear();
        _expandedProviders.add(cheapest!.provider);
      });

      if (widget.selectedRateId == null || widget.selectedRateId!.isEmpty) {
        widget.onRateSelected(cheapest);
      }
    }
  }

  Map<String, List<RateEntity>> _groupRatesByProvider() {
    final List<RateEntity> rates = _getAllRates();
    final Map<String, List<RateEntity>> grouped = <String, List<RateEntity>>{};
    for (final RateEntity rate in rates) {
      final ShippingProvider providerEnum = getProviderEnum(rate.provider);
      if (providerEnum == ShippingProvider.sendcloud) {
        // Group by carrier keyword (case-insensitive, partial match)
        final String carrier = rate.carrierAccount.trim().toLowerCase();
        String groupKey = 'Unknown Carrier';
        bool found = false;
        for (final MapEntry<ShippingProvider, List<String>> entry
            in providerKeywords.entries) {
          for (final String keyword in entry.value) {
            if (carrier.contains(keyword)) {
              groupKey =
                  providerDisplayNames[entry.key] ?? keyword.toUpperCase();
              found = true;
              break;
            }
          }
          if (found) break;
        }
        // If not found in carrier, fallback to token
        if (!found) {
          final String token = rate.serviceLevel.token.toLowerCase();
          for (final MapEntry<ShippingProvider, List<String>> entry
              in providerKeywords.entries) {
            for (final String keyword in entry.value) {
              if (token.contains(keyword)) {
                groupKey =
                    providerDisplayNames[entry.key] ?? keyword.toUpperCase();
                found = true;
                break;
              }
            }
            if (found) break;
          }
        }
        grouped.putIfAbsent(groupKey, () => <RateEntity>[]).add(rate);
      } else {
        final String groupKey = providerDisplayNames[providerEnum] ?? 'Other';
        grouped.putIfAbsent(groupKey, () => <RateEntity>[]).add(rate);
      }
    }
    for (final List<RateEntity> rateList in grouped.values) {
      rateList.sort((RateEntity a, RateEntity b) {
        final double priceA = double.tryParse(a.amountBuffered) ?? 0;
        final double priceB = double.tryParse(b.amountBuffered) ?? 0;
        return priceA.compareTo(priceB);
      });
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final List<RateEntity> rates = _getAllRates();

    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PostageHeader(detail: widget.detail),
          const SizedBox(height: AppSpacing.md),
          if (rates.isEmpty) _NoRatesMessage() else _buildRateList(rates),
        ],
      ),
    );
  }

  Widget _buildRateList(List<RateEntity> rates) {
    final Map<String, List<RateEntity>> groupedRates = _groupRatesByProvider();
    final List<String> providers = groupedRates.keys.toList();

    String selectedId = widget.selectedRateId ?? '';
    if (selectedId.isEmpty && rates.isNotEmpty && !_cheapestRateCalculated) {
      selectedId = rates.first.objectId;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onRateSelected(rates.first),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: providers.length,
      itemBuilder: (_, int providerIndex) {
        final String provider = providers[providerIndex];
        final List<RateEntity> providerRates = groupedRates[provider]!;
        final bool isExpanded = _expandedProviders.contains(provider);
        final String providerImage = providerRates.first.providerImage75;

        final bool hasSelected = providerRates.any(
          (r) => r.objectId == selectedId,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
              child: Container(
                decoration: BoxDecoration(
                  color: hasSelected
                      ? Theme.of(context).colorScheme.error.withValues(alpha: 0.12)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
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
            if (isExpanded)
              ...providerRates.map((RateEntity rate) {
                final bool isSelected = selectedId == rate.objectId;
                return InkWell(
                  onTap: () => widget.onRateSelected(rate),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.15)
                          : null,
                    ),
                    child: Row(
                      children: <Widget>[
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

class _PostageHeader extends StatelessWidget {
  const _PostageHeader({required this.detail});
  final PostageItemDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final PostEntity? post = LocalPost().post(detail.postId);

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
      ],
    );
  }
}

class _NoRatesMessage extends StatelessWidget {
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
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'no_rates_available'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
