import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../auth/signin/data/models/address_model.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../domain/entities/cart/cart_item_entity.dart';
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
    // Run checkout to fetch postage details once the widget is mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final CartProvider cartPro = context.read<CartProvider>();
      // Only call checkout if an address exists and postage not yet fetched
      if (cartPro.address != null && cartPro.postageResponseEntity == null) {
        cartPro.checkout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();

    return Column(
      children: <Widget>[
        // Address section
        InkWell(
          onTap: () async {
            final AddressEntity? newAddress =
                await showModalBottomSheet<AddressEntity?>(
              context: context,
              builder: (BuildContext context) {
                return AddressBottomSheet(initAddress: cartPro.address);
              },
            );
            if (newAddress != null) {
              cartPro.address = newAddress;
              // fetch postage for the newly selected address
              await cartPro.checkout();
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cartPro.address?.address ?? 'no_address'.tr(),
                        style: const TextStyle(fontSize: 13),
                      ),
                      if (cartPro.address != null) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          '${cartPro.address!.city}\n'
                          '${cartPro.address!.state.stateName}\n'
                          '${cartPro.address!.country.displayName}\n'
                          '${cartPro.address!.postalCode}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ]
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),

        // Postage options section (will render postage tiles when available)
        const SizedBox(height: 12),
        const PostageSection(),

        // Payment section removed — handled elsewhere
      ],
    );
  }
}

class PostageSection extends StatelessWidget {
  const PostageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    final PostageDetailResponseEntity? postage = cartPro.postageResponseEntity;
    if (postage == null || postage.detail.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> postIds =
        cartPro.cartItems.map((CartItemEntity e) => e.postID).toList();
    final List<PostageItemDetailEntity> items = postage.detail.entries
        .where((MapEntry<String, PostageItemDetailEntity> entry) =>
            postIds.contains(entry.key))
        .map((MapEntry<String, PostageItemDetailEntity> entry) => entry.value)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text('postage_options'.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              TextButton.icon(
                onPressed: () async {
                  // open postage bottom sheet to manage selections
                  final PostageDetailResponseEntity? postage =
                      cartPro.postageResponseEntity;
                  if (postage == null) return;
                  await showModalBottomSheet<Map<String, RateEntity>?>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: SafeArea(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: PostageBottomSheet(postage: postage))),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, size: 18),
                label: Text('edit'.tr()),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (BuildContext context, int index) {
            return PostageOptionTile(detail: items[index]);
          },
        ),
      ],
    );
  }
}

class PostageOptionTile extends StatelessWidget {
  const PostageOptionTile({required this.detail, super.key});
  final PostageItemDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    // Flatten available rates from shippingDetails
    final List<RateEntity> rates = <RateEntity>[];
    for (final PostageDetailShippingDetailEntity sd in detail.shippingDetails) {
      rates.addAll(sd.ratesBuffered);
    }

    final RateEntity? selected = cartPro.selectedPostageRates[detail.postId];

    return FutureBuilder<dynamic>(
      future: LocalPost().getPost(detail.postId, silentUpdate: true),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        final dynamic post = snap.data;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ColorScheme.of(context).outlineVariant,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CustomNetworkImage(
                      imageURL: post?.imageURL as String?, size: 56),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(post?.title ?? detail.postId,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(
                            'items: ${detail.itemCount} · parcels: ${detail.parcelCount}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post != null
                        ? (double.tryParse(post.price?.toString() ?? '0')
                                ?.toStringAsFixed(0) ??
                            '')
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (rates.isEmpty)
                Text('no_postage_options'.tr(),
                    style: Theme.of(context).textTheme.bodySmall)
              else
                Column(
                  children: rates.map((RateEntity rate) {
                    final String label =
                        '${rate.provider} · ${rate.serviceLevel.name} · ${rate.amount}';
                    return RadioListTile<RateEntity>(
                      value: rate,
                      groupValue: selected,
                      onChanged: (RateEntity? r) {
                        if (r != null) {
                          cartPro.selectPostageRate(detail.postId, r);
                        }
                      },
                      title: Text(label),
                      dense: true,
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
