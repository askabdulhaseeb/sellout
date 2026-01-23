import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/enums/listing/core/postage_type.dart';
import '../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../../postage/domain/entities/service_point_entity.dart';
import '../../../../../../../data/sources/local/local_cart.dart';
import '../../../../../../../domain/param/get_postage_detail_params.dart';
import '../../../../../../providers/cart_provider.dart';
import '../../../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../../../post/domain/entities/post/post_entity.dart';
import 'checkout_delivery_pickup_toggle.dart';
import 'service_points_dialog.dart';

class CheckoutItemTile extends StatefulWidget {
  const CheckoutItemTile({
    required this.item,
    this.forcedPostageType,
    super.key,
  });
  final CartItemEntity item;
  final PostageType? forcedPostageType;

  @override
  State<CheckoutItemTile> createState() => _CheckoutItemTileState();
}

class _CheckoutItemTileState extends State<CheckoutItemTile> {
  late Future<PostEntity?> _postFuture;
  bool _isLoadingServicePoints = false;

  @override
  void initState() {
    super.initState();
    _postFuture = LocalPost().getPost(widget.item.postID);
    // Apply any forced postage type after the first frame to avoid notifying
    // listeners during widget build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyForcedPostageType();
    });
  }

  @override
  void didUpdateWidget(covariant CheckoutItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-sync forced postage type changes after frame
    if (widget.forcedPostageType != oldWidget.forcedPostageType) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyForcedPostageType();
      });
    }
  }

  void _applyForcedPostageType() {
    final PostageType? forced = widget.forcedPostageType;
    if (forced == null || !mounted) return;

    final CartProvider cartProvider = context.read<CartProvider>();
    final bool isPickup = forced == PostageType.pickupOnly;
    final bool isAlreadyPickup = cartProvider.deliveryItems.any(
      (ItemDeliveryPreference pref) =>
          pref.cartItemId == widget.item.cartItemID &&
          pref.deliveryMode == 'pickup',
    );

    if (isPickup) {
      if (isAlreadyPickup) return;
      cartProvider.addOrUpdateDeliveryItem(
        ItemDeliveryPreference(
          cartItemId: widget.item.cartItemID,
          deliveryMode: 'pickup',
          servicePoint: null,
        ),
      );
    } else {
      if (isAlreadyPickup) {
        cartProvider.removeDeliveryItem(widget.item.cartItemID);
      }
    }
  }

  Future<void> _handlePostageTypeChange(PostageType value) async {
    AppLog.info(
      'Postage type changed to: $value for cart item: ${widget.item.cartItemID}',
      name: 'CheckoutItemTile._handlePostageTypeChange',
    );

    final CartProvider cartProvider = context.read<CartProvider>();

    if (value == PostageType.pickupOnly) {
      setState(() {
        _isLoadingServicePoints = true;
      });

      final String postalCode = cartProvider.address?.postalCode ?? '';
      final ServicePointEntity? selectedPoint = await _showServicePointsDialog(
        postalCode,
      );

      setState(() {
        _isLoadingServicePoints = false;
      });

      if (!mounted) return;

      // Only set pickup mode when a service point is chosen
      if (selectedPoint != null) {
        cartProvider.addOrUpdateDeliveryItem(
          ItemDeliveryPreference(
            cartItemId: widget.item.cartItemID,
            deliveryMode: 'pickup',
            servicePoint: selectedPoint,
          ),
        );
      } else {
        // If user cancelled, revert to delivery
        cartProvider.addOrUpdateDeliveryItem(
          ItemDeliveryPreference(
            cartItemId: widget.item.cartItemID,
            deliveryMode: 'delivery',
            servicePoint: null,
          ),
        );
      }
    } else {
      AppLog.info(
        'Delivery selected, removing from pickup list',
        name: 'CheckoutItemTile._handlePostageTypeChange',
      );

      // Remove from delivery items list
      cartProvider.removeDeliveryItem(widget.item.cartItemID);
    }
  }

  Future<ServicePointEntity?> _showServicePointsDialog(
    String postalCode,
  ) async {
    if (postalCode.isEmpty) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please add a delivery address before selecting pickup.',
          ).tr(),
        ),
      );
      return null;
    }

    final ServicePointEntity? selectedPoint = await ServicePointsDialog.show(
      context: context,
      cartItemIds: <String>[widget.item.cartItemID],
      postalCode: postalCode,
    );

    if (!mounted) return null;

    return selectedPoint;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider cartProvider, _) {
        // Get delivery preference from CartProvider
        final ItemDeliveryPreference? deliveryPref = cartProvider.deliveryItems
            .where((item) => item.cartItemId == widget.item.cartItemID)
            .firstOrNull;

        final PostageType selectedPostageType =
            deliveryPref?.deliveryMode == 'pickup'
            ? PostageType.pickupOnly
            : PostageType.postageOnly;

        return FutureBuilder<PostEntity?>(
          future: _postFuture,
          builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _CheckoutItemTileSkeleton(
                colorScheme: colorScheme,
                selectedPostageType: selectedPostageType,
                onPostageTypeChange: _handlePostageTypeChange,
                enabled: widget.forcedPostageType == null,
              );
            }

            final PostEntity? post = snapshot.data;
            return Column(
              children: <Widget>[
                const SizedBox(height: AppSpacing.xs),
                _CheckoutItemCard(
                  post: post,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  selectedPostageType: selectedPostageType,
                  isLoadingServicePoints: _isLoadingServicePoints,
                  onPostageTypeChange: _handlePostageTypeChange,
                  enabled: widget.forcedPostageType == null,
                ),

                if (selectedPostageType == PostageType.pickupOnly)
                  const SizedBox(height: AppSpacing.sm),
                if (selectedPostageType == PostageType.pickupOnly)
                  _PickupLocationPrompt(
                    servicePointName: deliveryPref?.servicePoint?.name,
                    titleSelect: 'select_pickup_location'.tr(),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    titleSelected: 'change'.tr(),
                    hintSelect: 'no_pickup_location_selected'.tr(),
                    onTap: () async {
                      final String postalCode =
                          cartProvider.address?.postalCode ?? '';
                      final ServicePointEntity? selectedPoint =
                          await _showServicePointsDialog(postalCode);

                      if (!mounted || selectedPoint == null) return;

                      cartProvider.addOrUpdateDeliveryItem(
                        ItemDeliveryPreference(
                          cartItemId: widget.item.cartItemID,
                          deliveryMode: 'pickup',
                          servicePoint: selectedPoint,
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CheckoutItemTileSkeleton extends StatelessWidget {
  const _CheckoutItemTileSkeleton({
    required this.colorScheme,
    required this.selectedPostageType,
    required this.onPostageTypeChange,
    required this.enabled,
  });

  final ColorScheme colorScheme;
  final PostageType selectedPostageType;
  final ValueChanged<PostageType> onPostageTypeChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
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
            value: selectedPostageType,
            onChanged: (PostageType value) =>
                enabled ? onPostageTypeChange : null,
          ),
        ],
      ),
    );
  }
}

class _CheckoutItemCard extends StatelessWidget {
  const _CheckoutItemCard({
    required this.post,
    required this.textTheme,
    required this.colorScheme,
    required this.selectedPostageType,
    required this.isLoadingServicePoints,
    required this.onPostageTypeChange,
    required this.enabled,
  });

  final PostEntity? post;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final PostageType selectedPostageType;
  final bool isLoadingServicePoints;
  final ValueChanged<PostageType> onPostageTypeChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    imageURL: post!.imageURL,
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
                post != null ? '£${post!.price.toStringAsFixed(2)}' : '',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        CheckoutDeliveryPickupToggle(
          showText: false,
          value: selectedPostageType,
          isLoading: isLoadingServicePoints,
          onChanged: (PostageType value) =>
              enabled ? onPostageTypeChange : null,
        ),
      ],
    );
  }
}

class _PickupLocationPrompt extends StatelessWidget {
  const _PickupLocationPrompt({
    required this.colorScheme,
    required this.textTheme,
    this.servicePointName,
    required this.titleSelected,
    required this.titleSelect,
    required this.hintSelect,
    this.onTap,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String? servicePointName;
  final String titleSelected;
  final String titleSelect;
  final String hintSelect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasSelection =
        servicePointName != null && servicePointName!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: hasSelection
                ? colorScheme.tertiaryContainer.withValues(
                    alpha: 0.25,
                  )
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: hasSelection
                  ? colorScheme.tertiary
                  : colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                hasSelection ? Icons.check_circle : Icons.location_on,
                color: hasSelection ? colorScheme.tertiary : colorScheme.error,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: hasSelection
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              servicePointName!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            titleSelected,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.tertiary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        hintSelect,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
