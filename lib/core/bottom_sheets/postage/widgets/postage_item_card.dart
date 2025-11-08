import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../../features/personal/post/data/sources/local/local_post.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../enums/listing/core/delivery_type.dart';
import '../../../helper_functions/country_helper.dart';
import '../../../constants/app_spacings.dart';
import '../../../widgets/custom_network_image.dart';
import '../../../widgets/shadow_container.dart';

class PostageItemCard extends StatelessWidget {
  const PostageItemCard({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    super.key,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    // Don't show postage cards for collection items at all
    final String rawType = detail.originalDeliveryType;
    final DeliveryType displayType = DeliveryType.fromJson(rawType);

    if (displayType == DeliveryType.collection) {
      return const SizedBox.shrink();
    }

    return _PostageCardContainer(
      child: _PostageCardContent(
        postId: postId,
        detail: detail,
        selected: selected,
        onSelect: onSelect,
        cartPro: cartPro,
      ),
    );
  }
}

class _PostageCardContainer extends StatelessWidget {
  const _PostageCardContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      showShadow: false,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: child,
      ),
    );
  }
}

class _PostageCardContent extends StatelessWidget {
  const _PostageCardContent({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _PostageCardHeader(postId: postId, detail: detail),
        _PostageCardRatesSection(
          postId: postId,
          detail: detail,
          selected: selected,
          onSelect: onSelect,
          cartPro: cartPro,
        ),
      ],
    );
  }
}

class _PostageCardHeader extends StatelessWidget {
  const _PostageCardHeader({
    required this.postId,
    required this.detail,
  });

  final String postId;
  final PostageItemDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainer
            .withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: _PostHeaderWidget(postId: postId, detail: detail),
    );
  }
}

class _PostHeaderWidget extends StatefulWidget {
  const _PostHeaderWidget({
    required this.postId,
    required this.detail,
  });

  final String postId;
  final PostageItemDetailEntity detail;

  @override
  State<_PostHeaderWidget> createState() => __PostHeaderWidgetState();
}

class __PostHeaderWidgetState extends State<_PostHeaderWidget>
    with SingleTickerProviderStateMixin {
  late final Future<PostEntity?> _postFuture;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _postFuture = LocalPost.openBox
        .then((_) => LocalPost().getPost(widget.postId, silentUpdate: true));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
      future: _postFuture,
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        if (snapshot.hasError) {
          return _PostHeaderErrorState(postId: widget.postId);
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const _PostHeaderLoadingState();
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: _PostHeaderContentState(
            post: snapshot.data,
            postId: widget.postId,
            detail: widget.detail,
          ),
        );
      },
    );
  }
}

class _PostHeaderErrorState extends StatelessWidget {
  const _PostHeaderErrorState({required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 28,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'error_loading_post'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                postId,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostHeaderLoadingState extends StatelessWidget {
  const _PostHeaderLoadingState();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainer
                      .withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostHeaderContentState extends StatelessWidget {
  const _PostHeaderContentState({
    required this.post,
    required this.postId,
    required this.detail,
  });

  final PostEntity? post;
  final String postId;
  final PostageItemDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    // Check if delivery rates are available
    final List<RateEntity> rates = detail.shippingDetails
        .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
        .toList();

    final String rawType = detail.originalDeliveryType;
    final DeliveryType deliveryType = DeliveryType.fromJson(rawType);

    // Determine delivery availability
    final bool hasDeliveryRates = rates.isNotEmpty;
    final bool isFreeDelivery = deliveryType == DeliveryType.freeDelivery;
    final bool isCollection = deliveryType == DeliveryType.collection;

    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: ColorScheme.of(context).outline,
              borderRadius: BorderRadius.circular(6)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Icon(
                CupertinoIcons.cube_box,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              )),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      post?.title ?? 'unknown_product'.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Show delivery availability tag for all delivery types except collection
                  if (!isCollection) ...<Widget>[
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isFreeDelivery || hasDeliveryRates)
                            ? Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.2)
                            : Theme.of(context)
                                .colorScheme
                                .errorContainer
                                .withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusXs),
                        border: Border.all(
                          color: (isFreeDelivery || hasDeliveryRates)
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3)
                              : Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 10,
                            color: (isFreeDelivery || hasDeliveryRates)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            isFreeDelivery
                                ? 'free_delivery'.tr()
                                : hasDeliveryRates
                                    ? 'delivery_available'.tr()
                                    : 'delivery_unavailable'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: (isFreeDelivery || hasDeliveryRates)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostageCardRatesSection extends StatelessWidget {
  const _PostageCardRatesSection({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: _PostageShippingOptionsContent(
        postId: postId,
        detail: detail,
        selected: selected,
        onSelect: onSelect,
        cartPro: cartPro,
      ),
    );
  }
}

class _PostageShippingOptionsContent extends StatelessWidget {
  const _PostageShippingOptionsContent({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    final List<RateEntity> rates = detail.shippingDetails
        .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
        .toList();

    final String rawType = detail.originalDeliveryType;
    final DeliveryType displayType = DeliveryType.fromJson(rawType);

    // Check if this is a delivery type that requires rates but has none
    final bool isDeliveryNeeded = displayType == DeliveryType.paid ||
        displayType == DeliveryType.fastDelivery;
    final bool hasNoRates = rates.isEmpty;
    final bool shouldShowRemoveMessage = isDeliveryNeeded && hasNoRates;

    // Only show rates section for paid delivery and fast delivery when rates are available
    if (rates.isEmpty ||
        displayType == DeliveryType.freeDelivery ||
        displayType == DeliveryType.collection ||
        (displayType != DeliveryType.paid &&
            displayType != DeliveryType.fastDelivery)) {
      // Show remove message for delivery types that need rates but don't have them
      if (shouldShowRemoveMessage) {
        return _PostageRemoveMessage();
      }
      return const SizedBox.shrink();
    }

    // Show rates for paid delivery and fast delivery
    final RateEntity defaultRate = rates.first;
    final String defaultKey =
        '${defaultRate.provider}::${defaultRate.serviceLevel.token}::${defaultRate.amountBuffered.isNotEmpty ? defaultRate.amountBuffered : defaultRate.amount}';
    final String selectedKey = selected.containsKey(postId)
        ? '${selected[postId]!.provider}::${selected[postId]!.serviceLevel.token}::${selected[postId]!.amountBuffered.isNotEmpty ? selected[postId]!.amountBuffered : selected[postId]!.amount}'
        : defaultKey;

    return _PostageRatesListWidget(
      rates: rates,
      postId: postId,
      selectedKey: selectedKey,
      onSelect: onSelect,
    );
  }
}

class _PostageRatesListWidget extends StatelessWidget {
  const _PostageRatesListWidget({
    required this.rates,
    required this.postId,
    required this.selectedKey,
    required this.onSelect,
  });

  final List<RateEntity> rates;
  final String postId;
  final String selectedKey;
  final void Function(String, RateEntity) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'postage_options'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...rates.asMap().entries.map((MapEntry<int, RateEntity> entry) {
          final int index = entry.key;
          final RateEntity rate = entry.value;
          final bool isLast = index == rates.length - 1;

          return _PostageRateOptionWidget(
            rate: rate,
            postId: postId,
            selectedKey: selectedKey,
            isLast: isLast,
            onSelect: onSelect,
          );
        }),
      ],
    );
  }
}

class _PostageRemoveMessage extends StatelessWidget {
  const _PostageRemoveMessage();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .errorContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'remove_item_cart_continue_checkout'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostageRateOptionWidget extends StatelessWidget {
  const _PostageRateOptionWidget({
    required this.rate,
    required this.postId,
    required this.selectedKey,
    required this.isLast,
    required this.onSelect,
  });

  final RateEntity rate;
  final String postId;
  final String selectedKey;
  final bool isLast;
  final void Function(String, RateEntity) onSelect;

  @override
  Widget build(BuildContext context) {
    final String label = '${rate.provider} · ${rate.serviceLevel.name}';
    final String key =
        '${rate.provider}::${rate.serviceLevel.token}::${rate.amountBuffered.isNotEmpty ? rate.amountBuffered : rate.amount}';

    // Get the amount with currency symbol
    final String amount =
        rate.amountBuffered.isNotEmpty ? rate.amountBuffered : rate.amount;

    // Try to extract currency from the amount string or use GBP as default
    String currency = 'GBP'; // Default fallback
    String cleanAmount = amount;

    // Check if amount already contains currency symbols
    if (!amount.contains('£') &&
        !amount.contains('\$') &&
        !amount.contains('€')) {
      cleanAmount = '${CountryHelper.currencySymbolHelper(currency)}$amount';
    } else {
      cleanAmount = amount;
    }

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        leading: Radio<String>(
          value: key,
          groupValue: selectedKey,
          onChanged: (String? value) {
            if (value != null) {
              final RateEntity found = <RateEntity>[rate].firstWhere(
                (RateEntity rr) =>
                    '${rr.provider}::${rr.serviceLevel.token}::${rr.amountBuffered.isNotEmpty ? rr.amountBuffered : rr.amount}' ==
                    key,
                orElse: () => rate,
              );
              onSelect(postId, found);
            }
          },
        ),
        title: Row(
          children: <Widget>[
            if (rate.providerImage75.isNotEmpty) ...<Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  child: CustomNetworkImage(
                    imageURL: rate.providerImage75,
                    fit: BoxFit.contain,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Text(
              cleanAmount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        onTap: () {
          final RateEntity found = <RateEntity>[rate].firstWhere(
            (RateEntity rr) =>
                '${rr.provider}::${rr.serviceLevel.token}::${rr.amountBuffered.isNotEmpty ? rr.amountBuffered : rr.amount}' ==
                key,
            orElse: () => rate,
          );
          onSelect(postId, found);
        },
      ),
    );
  }
}
