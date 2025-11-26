import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
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

      if (cartPro.address == null) {
        final List<AddressEntity> addresses =
            LocalAuth.currentUser?.address ?? <AddressEntity>[];

        if (addresses.isNotEmpty) {
          // FIXED: orElse must return AddressEntity
          final AddressEntity def = addresses.firstWhere(
            (AddressEntity a) => a.isDefault,
          );
          cartPro.setAddress(def);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _SimpleCheckoutAddressSection(),
          SizedBox(height: 12),
          _SimplePostageSection(),
        ],
      ),
    );
  }
}

// ----------------- Address Section -----------------
class _SimpleCheckoutAddressSection extends StatefulWidget {
  const _SimpleCheckoutAddressSection();

  @override
  State<_SimpleCheckoutAddressSection> createState() =>
      _SimpleCheckoutAddressSectionState();
}

class _SimpleCheckoutAddressSectionState
    extends State<_SimpleCheckoutAddressSection> {
  bool _isLoading = false;

  Future<void> _onAddressTap(CartProvider cartPro) async {
    final AddressEntity? newAddress = await showModalBottomSheet<AddressEntity>(
      context: context,
      builder: (_) => AddressBottomSheet(initAddress: cartPro.address),
    );

    if (newAddress != null) {
      setState(() => _isLoading = true);
      cartPro.setAddress(newAddress);
      await cartPro.getRates();
      setState(() => _isLoading = false);

      if (mounted && cartPro.postageResponseEntity != null) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) =>
              PostageBottomSheet(postage: cartPro.postageResponseEntity!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, CartProvider cartPro, __) => InkWell(
        onTap: () => _onAddressTap(cartPro),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorScheme.of(context).outlineVariant),
          ),
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
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    Text(cartPro.address?.address1 ?? 'no_address'.tr(),
                        style: const TextStyle(fontSize: 13, height: 1.4)),
                    if (cartPro.address != null)
                      Text(
                        '${cartPro.address!.city}, ${cartPro.address?.state?.stateName ?? 'na'.tr()}'
                        '\n${cartPro.address?.country.displayName} ${cartPro.address?.postalCode}',
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- Postage Section -----------------
class _SimplePostageSection extends StatefulWidget {
  const _SimplePostageSection();

  @override
  State<_SimplePostageSection> createState() => _SimplePostageSectionState();
}

class _SimplePostageSectionState extends State<_SimplePostageSection> {
  // Fetch posts from local storage
  Future<Map<String, PostEntity?>> _getPosts() async {
    await LocalPost.openBox;
    final CartProvider cartPro = context.read<CartProvider>();
    final Map<String, PostEntity?> posts = <String, PostEntity?>{};
    for (final String id in cartPro.postageResponseEntity!.detail.keys) {
      posts[id] = await LocalPost().getPost(id, silentUpdate: true);
    }
    return posts;
  }

  // Fetch converted price strings asynchronously
  Future<Map<String, String>> _getConvertedPrices(CartProvider cartPro) async {
    final Map<String, String> prices = <String, String>{};
    for (final MapEntry<String, PostageItemDetailEntity> entry
        in cartPro.postageResponseEntity!.detail.entries) {
      final String postId = entry.key;
      final RateEntity? rate = cartPro.selectedPostageRates[postId];
      if (rate != null) {
        prices[postId] = await rate.getPriceStr(); // await async price
      }
    }
    return prices;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, CartProvider cartPro, __) {
        if (cartPro.postageResponseEntity == null) {
          return const SizedBox.shrink();
        }
        final bool isLoading = cartPro.loadingPostage;

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            if (!isLoading) {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) =>
                    PostageBottomSheet(postage: cartPro.postageResponseEntity!),
              );
              // Rebuild after selecting postage rates
              setState(() {});
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorScheme.of(context).outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${'postage'.tr()}:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    )),
                const SizedBox(height: 8),
                if (isLoading)
                  const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  FutureBuilder<Map<String, PostEntity?>>(
                    future: _getPosts(),
                    builder:
                        (_, AsyncSnapshot<Map<String, PostEntity?>> snapPosts) {
                      if (!snapPosts.hasData) return const SizedBox.shrink();
                      final Map<String, PostEntity?> posts = snapPosts.data!;
                      return FutureBuilder<Map<String, String>>(
                        future: _getConvertedPrices(cartPro),
                        builder:
                            (_, AsyncSnapshot<Map<String, String>> snapPrices) {
                          if (!snapPrices.hasData) {
                            return const SizedBox.shrink();
                          }
                          final Map<String, String> prices = snapPrices.data!;
                          final List<Widget> items = <Widget>[];
                          for (final MapEntry<String,
                                  PostageItemDetailEntity> entry
                              in cartPro
                                  .postageResponseEntity!.detail.entries) {
                            final String postId = entry.key;
                            final PostageItemDetailEntity detail = entry.value;
                            final String title =
                                posts[postId]?.title ?? 'unknown_product'.tr();

                            final String? priceStr = prices[postId];
                            if (priceStr != null) {
                              items.add(_row(title, priceStr, context));
                            } else {
                              final bool isFree = detail.originalDeliveryType
                                  .toLowerCase()
                                  .contains('free');
                              items.add(_row(
                                  title,
                                  isFree ? 'free'.tr() : 'tap_to_select'.tr(),
                                  context,
                                  italic: true));
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ...items,
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _row(String title, String trailing, BuildContext context,
      {bool isBold = false, bool italic = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Text(trailing,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                    color: color,
                  )),
        ],
      ),
    );
  }
}
