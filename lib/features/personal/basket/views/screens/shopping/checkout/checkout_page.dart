import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../auth/signin/data/models/address_model.dart';
import '../../../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final CartProvider cartPro = context.read<CartProvider>();
      if (cartPro.address != null && cartPro.postageResponseEntity == null) {
        cartPro.getRates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () async {
              final AddressEntity? newAddress =
                  await showModalBottomSheet<AddressEntity>(
                context: context,
                builder: (BuildContext context) {
                  return AddressBottomSheet(initAddress: cartPro.address);
                },
              );
              if (newAddress != null) {
                cartPro.address = newAddress;
                await cartPro.getRates();
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorScheme.of(context).outlineVariant,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${'post_to'.tr()}:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cartPro.address?.address ?? 'no_address'.tr(),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        if (cartPro.address != null) ...<Widget>[
                          const SizedBox(height: 4),
                          Text(
                            '${cartPro.address!.city}, ${cartPro.address!.state.stateName}\n'
                            '${cartPro.address!.country.displayName} ${cartPro.address!.postalCode}',
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              // Ensure postage details are available before opening sheet
              if (cartPro.postageResponseEntity == null) {
                await cartPro.getRates();
              }
              if (cartPro.postageResponseEntity == null) return;
              final Map<String, RateEntity>? newSelection =
                  await showModalBottomSheet<Map<String, RateEntity>>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return PostageBottomSheet(
                      postage: cartPro.postageResponseEntity!);
                },
              );

              // PostageBottomSheet updates provider when Apply is pressed.
              // If a selection map is returned, refresh local UI.
              if (newSelection != null) {
                setState(() {});
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorScheme.of(context).outlineVariant,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${'postage'.tr()}:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Show warning if items need to be removed
                          if (cartPro.hasItemsRequiringRemoval) ...<Widget>[
                            _CheckoutRemovalWarningInline(
                                postIds: cartPro.itemsRequiringRemovalPostIds),
                          ] else if (cartPro.postageResponseEntity !=
                              null) ...<Widget>[
                            // Show all items with their postage information
                            _PostageItemsList(
                              postageResponse: cartPro.postageResponseEntity!,
                              selectedRates: cartPro.selectedPostageRates,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostageItemsList extends StatelessWidget {
  const _PostageItemsList({
    required this.postageResponse,
    required this.selectedRates,
  });

  final PostageDetailResponseEntity postageResponse;
  final Map<String, RateEntity> selectedRates;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, PostEntity?>>(
      future: _loadPosts(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, PostEntity?>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final Map<String, PostEntity?> posts = snapshot.data ?? <String, PostEntity?>{};
        final List<Widget> items = <Widget>[];
        double total = 0.0;

        // Show ONLY items that actually need postage (have payable rates).
        // Exclude items whose originalDeliveryType is 'free' or 'collection',
        // and any items that have no available rates (e.g. free/collection or failed calc).
        for (final MapEntry<String, PostageItemDetailEntity> entry in postageResponse.detail.entries) {
          final String postId = entry.key;
          final PostEntity? post = posts[postId];
          final String title = post?.title ?? 'unknown_product'.tr();
          final String currencySymbol = post?.currency ?? '';

          final PostageItemDetailEntity detail = entry.value;
          final String deliveryType =
              detail.originalDeliveryType.toLowerCase().trim();

          // Aggregate buffered rates for this item.
          final List<RateEntity> availableRates = detail.shippingDetails
              .expand(
                  (PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
              .toList();

          final bool isExcludedType =
              deliveryType == 'free' || deliveryType == 'collection';
          final bool hasPayableRates = availableRates.isNotEmpty;

          // Skip rendering if item does not require postage selection.
          if (isExcludedType || !hasPayableRates) {
            continue;
          }

          // Check if rate is selected
          final RateEntity? rate = selectedRates[postId];

          if (rate != null) {
            // Parse rate amount
            String candidate = rate.amountBuffered.isNotEmpty
                ? rate.amountBuffered
                : rate.amount;
            final String cleaned = candidate.replaceAll(RegExp(r"[^0-9.-]"), '');
            final double parsed = double.tryParse(cleaned) ?? 0.0;
            total += parsed;

            items.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$currencySymbol ${parsed.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // No rate selected - show item with "Select shipping" message
            items.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'tap_to_select'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        if (items.isEmpty) {
          return Text('no_items_found'.tr(),
              style: Theme.of(context).textTheme.bodySmall);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...items,
            if (selectedRates.isNotEmpty) ...<Widget>[
              const Divider(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'total'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    // Use first rendered item's currency if available
                    posts.values.first?.currency != null
                        ? '${posts.values.first!.currency} ${total.toStringAsFixed(2)}'
                        : total.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Future<Map<String, PostEntity?>> _loadPosts() async {
    await LocalPost.openBox;
    final Map<String, PostEntity?> result = <String, PostEntity?>{};
    for (final String postId in postageResponse.detail.keys) {
      result[postId] = await LocalPost().getPost(postId, silentUpdate: true);
    }
    return result;
  }
}

class _CheckoutRemovalWarningInline extends StatefulWidget {
  const _CheckoutRemovalWarningInline({required this.postIds});
  final List<String> postIds;

  @override
  State<_CheckoutRemovalWarningInline> createState() =>
      _CheckoutRemovalWarningInlineState();
}

class _CheckoutRemovalWarningInlineState
    extends State<_CheckoutRemovalWarningInline> {
  Future<List<String>> _loadTitles(List<String> ids) async {
    await LocalPost.openBox;
    final List<String> limited = ids.take(3).toList();
    final List<PostEntity?> posts = await Future.wait(
      limited.map((String id) => LocalPost().getPost(id, silentUpdate: true)),
    );
    final List<String> titles = <String>[];
    for (int i = 0; i < limited.length; i++) {
      titles.add(posts[i]?.title ?? limited[i]);
    }
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> ids = widget.postIds;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.warning_amber_rounded,
                  size: 16, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'remove_item_cart_continue_checkout'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          FutureBuilder<List<String>>(
            future: _loadTitles(ids),
            builder: (BuildContext context, AsyncSnapshot<List<String>> snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }
              final List<String> titles = snap.data ?? <String>[];
              if (titles.isEmpty) return const SizedBox.shrink();
              final int remaining = ids.length - titles.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...titles.map((String t) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: <Widget>[
                            Text('• ',
                                style: Theme.of(context).textTheme.bodySmall),
                            Expanded(
                              child: Text(
                                t,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (remaining > 0)
                    Text(
                      '+$remaining more',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).hintColor, fontSize: 11),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
