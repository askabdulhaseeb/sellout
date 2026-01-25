import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../../../core/enums/listing/core/postage_type.dart';
import '../../../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../../../../domain/param/get_postage_detail_params.dart';
import '../../../../../providers/cart_provider.dart';
import 'checkout_item_seller_header.dart';
import 'components/checkout_item_tile.dart';
import 'components/service_points_dialog.dart';
import 'models/seller_group.dart';

class CheckoutItemsList extends StatefulWidget {
  const CheckoutItemsList({super.key});

  @override
  State<CheckoutItemsList> createState() => _CheckoutItemsListState();
}

class _CheckoutItemsListState extends State<CheckoutItemsList> {
  final Map<int, PostageType> _groupPostageType = <int, PostageType>{};

  @override
  void initState() {
    super.initState();
    // Defer loading to after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroupedItems();
    });
  }

  void _loadGroupedItems() {
    final CartProvider cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    cartProvider.loadGroupedItems();
  }

  void _updateGroupPostage(int groupIndex, PostageType value) async {
    final CartProvider cartProvider = context.read<CartProvider>();
    final SellerGroup? group = cartProvider.groupedSellerItems?[groupIndex];

    if (group == null) return;

    if (value == PostageType.pickup) {
      // Show service points dialog for group
      final String postalCode = cartProvider.address?.postalCode ?? '';
      if (postalCode.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'please_add_delivery_address_before_selecting_pickup'.tr(),
            ),
          ),
        );
        return;
      }

      // Get cartItemIds for all items in this group
      final List<String> cartItemIds = group.items
          .map((CartItemEntity item) => item.cartItemID)
          .toList();

      if (!mounted) return;
      final dynamic selectedPoint = await ServicePointsDialog.show(
        context: context,
        cartItemIds: cartItemIds,
        postalCode: postalCode,
      );

      if (!mounted) return;

      if (selectedPoint != null) {
        // Apply the same pickup location to all items in the group
        for (final String cartItemId in cartItemIds) {
          cartProvider.addOrUpdateDeliveryItem(
            ItemDeliveryPreference(
              cartItemId: cartItemId,
              deliveryMode: 'pickup',
              servicePoint: selectedPoint,
            ),
          );
        }

        setState(() {
          _groupPostageType[groupIndex] = value;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('no_pickup_location_selected'.tr())),
        );
      }
    } else {
      // Clear pickup locations for all items when switching back to delivery
      for (final CartItemEntity item in group.items) {
        cartProvider.removeDeliveryItem(item.cartItemID);
      }

      setState(() {
        _groupPostageType[groupIndex] = value;
      });
    }
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
              'your_cart_is_empty'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('items'.tr(), style: Theme.of(context).textTheme.titleMedium),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int groupIndex) {
                final SellerGroup group = groups[groupIndex];
                final PostageType groupPostageType =
                    _groupPostageType[groupIndex] ?? PostageType.home;
                return ShadowContainer(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (group.seller != null)
                        CartSellerHeader(
                          seller: group.seller!,
                          itemCount: group.items.length,
                          postageType: groupPostageType,
                          onPostageTypeChanged: (PostageType value) =>
                              _updateGroupPostage(groupIndex, value),
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
                              child: CheckoutItemTile(
                                item: group.items[i],
                                forcedPostageType: groupPostageType,
                              ),
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
