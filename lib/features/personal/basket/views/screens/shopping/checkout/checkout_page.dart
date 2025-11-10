import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
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
                              fastDeliveryPostIds:
                                  cartPro.fastDeliveryProducts.toSet(),
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
    required this.fastDeliveryPostIds,
  });

  final PostageDetailResponseEntity postageResponse;
  final Map<String, RateEntity> selectedRates;
  final Set<String> fastDeliveryPostIds;

  static final RegExp _currencySymbolRegex = RegExp(r'[£€$₨₹¥₺₽]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');
  static final RegExp _letterRegex = RegExp(r'[A-Za-z]');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, PostEntity?>>(
      future: _loadPosts(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, PostEntity?>> snapshot) {
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

        final Map<String, PostEntity?> posts =
            snapshot.data ?? <String, PostEntity?>{};
        final List<Widget> items = <Widget>[];
        double total = 0.0;
        String? totalSymbol;
        String? totalCurrencyCode;

        for (final MapEntry<String, PostageItemDetailEntity> entry
            in postageResponse.detail.entries) {
          final String postId = entry.key;
          final PostEntity? post = posts[postId];
          final String title = post?.title ?? 'unknown_product'.tr();

          final PostageItemDetailEntity detail = entry.value;
          final String deliveryType =
              detail.originalDeliveryType.toLowerCase().trim();
          final bool fastDeliverySelected =
              fastDeliveryPostIds.contains(postId);
          final bool isFree = deliveryType == 'free';
          final bool isCollection = deliveryType == 'collection';
          final bool isPaidDelivery = deliveryType.contains('paid');
          final bool isFastDelivery = deliveryType.contains('fast');

          // Aggregate buffered rates for this item.
          final List<RateEntity> availableRates = detail.shippingDetails
              .expand(
                  (PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
              .toList();

          final bool hasPayableRates = availableRates.isNotEmpty;
          final bool showRatesForFreeFast = isFree && fastDeliverySelected;

          if (isCollection) {
            continue;
          }

          // Skip rendering if item does not require postage selection.
          final bool requiresRates = isPaidDelivery ||
              isFastDelivery ||
              showRatesForFreeFast ||
              (isFree && hasPayableRates);
          if (!isFree && !requiresRates && !hasPayableRates) {
            continue;
          }

          // Check if rate is selected
          final RateEntity? rate = selectedRates[postId];

          if (rate != null) {
            final _AmountInfo amountInfo = _resolveAmount(rate, post);
            total += amountInfo.numeric;
            totalSymbol ??= amountInfo.symbol;
            totalCurrencyCode ??= amountInfo.currencyCode;

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
                      amountInfo.display,
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
            final Widget trailing;
            if (isFree && !showRatesForFreeFast) {
              trailing = Text(
                'free'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              );
            } else if ((requiresRates && hasPayableRates) ||
                (!isFree && hasPayableRates)) {
              trailing = Text(
                'tap_to_select'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.outline,
                    ),
              );
            } else {
              continue;
            }

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
                    trailing,
                  ],
                ),
              ),
            );
          }
        }

        if (items.isEmpty) {
          return Text('no_item_available'.tr(),
              style: Theme.of(context).textTheme.bodySmall);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...items,
            if (total > 0) ...<Widget>[
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
                    _formatTotal(total, totalSymbol, totalCurrencyCode),
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

  static _AmountInfo _resolveAmount(RateEntity rate, PostEntity? post) {
    final String raw =
        (rate.amountBuffered.isNotEmpty ? rate.amountBuffered : rate.amount)
            .trim();
    final double numeric = _parseNumericAmount(raw);

    String? currencyCode =
        rate.currency.isNotEmpty ? rate.currency : post?.currency;
    currencyCode = (currencyCode != null && currencyCode.isNotEmpty)
        ? currencyCode.toUpperCase()
        : null;

    final String resolvedSymbol =
        CountryHelper.currencySymbolHelper(currencyCode);
    String display = raw;
    final bool hasDigits = _digitRegex.hasMatch(raw);
    final bool hasSymbol = _currencySymbolRegex.hasMatch(raw);
    final bool hasLetters = _letterRegex.hasMatch(raw);

    if (display.isEmpty && numeric > 0) {
      display = numeric.toStringAsFixed(2);
    }

    if (!hasSymbol && hasDigits && !hasLetters) {
      if (resolvedSymbol.isNotEmpty) {
        display = '$resolvedSymbol${numeric.toStringAsFixed(2)}';
      } else if (currencyCode != null) {
        display = '$currencyCode ${numeric.toStringAsFixed(2)}';
      } else if (display.isEmpty) {
        display = numeric.toStringAsFixed(2);
      }
    } else if (display.isEmpty) {
      display = numeric.toStringAsFixed(2);
    }

    String? symbol = _currencySymbolRegex.firstMatch(display)?.group(0);
    if ((symbol == null || symbol.isEmpty) && resolvedSymbol.isNotEmpty) {
      symbol = resolvedSymbol;
    }

    return _AmountInfo(
      display: display.isNotEmpty ? display : numeric.toStringAsFixed(2),
      numeric: numeric,
      symbol: symbol,
      currencyCode: currencyCode,
    );
  }

  static double _parseNumericAmount(String raw) {
    if (raw.isEmpty) return 0.0;
    final String cleaned = raw.replaceAll(RegExp(r'[^0-9.+-]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  static String _formatTotal(
      double total, String? symbol, String? currencyCode) {
    final String value = total.toStringAsFixed(2);
    if (symbol != null && symbol.isNotEmpty) {
      return '$symbol$value';
    }
    if (currencyCode != null && currencyCode.isNotEmpty) {
      final String resolvedSymbol =
          CountryHelper.currencySymbolHelper(currencyCode);
      if (resolvedSymbol.isNotEmpty) {
        return '$resolvedSymbol$value';
      }
      return '$currencyCode $value';
    }
    return value;
  }
}

class _AmountInfo {
  const _AmountInfo({
    required this.display,
    required this.numeric,
    this.symbol,
    this.currencyCode,
  });

  final String display;
  final double numeric;
  final String? symbol;
  final String? currencyCode;
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
