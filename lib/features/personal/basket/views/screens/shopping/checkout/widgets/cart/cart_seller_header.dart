import 'package:flutter/material.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../user/profiles/domain/entities/user_entity.dart';
import 'components/cart_delivery_pickup_toggle.dart';

class CartSellerHeader extends StatelessWidget {
  const CartSellerHeader({
    required this.seller,
    required this.itemCount,
    super.key,
  });
  final UserEntity seller;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colorScheme.outline,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusSm),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomNetworkImage(
                size: 24,
                imageURL:
                    seller.profilePhotoURL != null &&
                        seller.profilePhotoURL!.isNotEmpty
                    ? seller.profilePhotoURL!
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      seller.displayName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '$itemCount item${itemCount > 1 ? 's' : ''}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const CartDeliveryPickupToggle(),
      ],
    );
  }
}
