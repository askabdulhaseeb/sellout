import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../providers/cart_provider.dart';
import 'checkout_item_seller_header.dart';
import 'components/checkout_item_tile.dart';
import 'models/seller_group.dart';

class CheckoutItemsList extends StatefulWidget {
  const CheckoutItemsList({super.key});

  @override
  State<CheckoutItemsList> createState() => _CheckoutItemsListState();
}

class _CheckoutItemsListState extends State<CheckoutItemsList> {
  @override
  void initState() {
    super.initState();
    _loadGroupedItems();
  }

  void _loadGroupedItems() {
    final CartProvider cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    cartProvider.loadGroupedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider provider, _) {
        if (provider.isLoadingGroupedItems) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<SellerGroup> groups =
            provider.groupedSellerItems ?? <SellerGroup>[];
        if (groups.isEmpty) {
          return Center(
            child: Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                'items'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int groupIndex) {
                final SellerGroup group = groups[groupIndex];

                return ShadowContainer(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (group.seller != null)
                        CartSellerHeader(
                          seller: group.seller!,
                          itemCount: group.items.length,
                        ),
                      Column(
                        children: <Widget>[
                          for (
                            int i = 0;
                            i < group.items.length;
                            i++
                          ) ...<Widget>[
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: CheckoutItemTile(item: group.items[i]),
                            ),
                            if (i < group.items.length - 1)
                              Divider(
                                height: 1,
                                color: Colors.grey[200],
                                indent: AppSpacing.md,
                                endIndent: AppSpacing.md,
                              ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
