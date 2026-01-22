import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/enums/listing/core/postage_type.dart';
import '../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../data/sources/local/local_cart.dart';
import '../../../../../../providers/cart_provider.dart';
import '../../../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../../../post/domain/entities/post/post_entity.dart';
import 'checkout_delivery_pickup_toggle.dart';

class CheckoutItemTile extends StatefulWidget {
  const CheckoutItemTile({required this.item, super.key});
  final CartItemEntity item;

  @override
  State<CheckoutItemTile> createState() => _CheckoutItemTileState();
}

class _CheckoutItemTileState extends State<CheckoutItemTile> {
  late Future<PostEntity?> _postFuture;
  PostageType _selectedPostageType = PostageType.postageOnly;

  @override
  void initState() {
    super.initState();
    _postFuture = LocalPost().getPost(widget.item.postID);
  }

  Future<void> _handlePostageTypeChange(PostageType value) async {
    AppLog.info(
      'Postage type changed to: $value for cart item: ${widget.item.cartItemID}',
      name: 'CheckoutItemTile._handlePostageTypeChange',
    );

    // Print detailed information
    debugPrint('=== POSTAGE TYPE CHANGE ===');
    debugPrint('Cart Item ID: ${widget.item.cartItemID}');
    debugPrint('Post ID: ${widget.item.postID}');
    debugPrint('Previous Type: $_selectedPostageType');
    debugPrint('New Type: $value');
    debugPrint('Is Delivery: ${value == PostageType.postageOnly}');
    debugPrint('Is Pickup: ${value == PostageType.pickupOnly}');
    debugPrint('===========================');

    if (value == PostageType.pickupOnly) {
      final CartProvider cartProvider = Provider.of<CartProvider>(
        context,
        listen: false,
      );

      AppLog.info(
        'Fetching service points for cart item: ${widget.item.cartItemID}',
        name: 'CheckoutItemTile._handlePostageTypeChange',
      );

      // TODO: Get actual postal code and carrier from address/item
      await cartProvider.fetchServicePoints(
        cartItemId: widget.item.cartItemID,
       carrier: '', // Replace with actual carrier
      );

      // Print service points data after fetch
      final servicePoints = cartProvider.getServicePoints(
        widget.item.cartItemID,
      );
      debugPrint('Service Points Count: ${servicePoints?.length ?? 0}');
      if (servicePoints != null && servicePoints.isNotEmpty) {
        debugPrint('First Service Point: ${servicePoints.first.name}');
      }
    } else {
      AppLog.info(
        'Delivery selected, clearing service points if any',
        name: 'CheckoutItemTile._handlePostageTypeChange',
      );
    }

    setState(() {
      _selectedPostageType = value;
    });

    AppLog.info(
      'State updated: $_selectedPostageType',
      name: 'CheckoutItemTile._handlePostageTypeChange',
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider cartProvider, _) {
        final bool isLoadingServicePoints = cartProvider.isLoadingServicePoints(
          widget.item.cartItemID,
        );

        return FutureBuilder<PostEntity?>(
          future: _postFuture,
          builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeleton(colorScheme);
            }

            final PostEntity? post = snapshot.data;
            return _buildCartTile(
              post,
              textTheme,
              colorScheme,
              isLoadingServicePoints,
            );
          },
        );
      },
    );
  }

  Widget _buildSkeleton(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 16,
                  width: 120,
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 14,
                  width: 60,
                  color: colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          CheckoutDeliveryPickupToggle(
            showText: false,
            value: _selectedPostageType,
            onChanged: _handlePostageTypeChange,
          ),
        ],
      ),
    );
  }

  Widget _buildCartTile(
    dynamic post,
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isLoadingServicePoints,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: post?.imageURL != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    child: CustomNetworkImage(
                      imageURL: post?.imageURL,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.inventory_2_outlined,
                    color: colorScheme.outlineVariant,
                    size: 36,
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post?.title ?? '',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  post != null ? '£${post.price.toStringAsFixed(2)}' : '',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                CheckoutDeliveryPickupToggle(
                  showText: false,
                  value: _selectedPostageType,
                  isLoading: isLoadingServicePoints,
                  onChanged: _handlePostageTypeChange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
