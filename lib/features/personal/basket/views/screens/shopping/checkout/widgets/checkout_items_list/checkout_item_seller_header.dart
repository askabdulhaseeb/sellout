import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/enums/listing/core/postage_type.dart';
import '../../../../../../../user/profiles/domain/entities/user_entity.dart';
import 'components/checkout_delivery_pickup_toggle.dart';

class CartSellerHeader extends StatelessWidget {
  const CartSellerHeader({
    required this.seller,
    required this.itemCount,
    required this.postageType,
    required this.onPostageTypeChanged,
    super.key,
  });
  final UserEntity seller;
  final int itemCount;
  final PostageType postageType;
  final ValueChanged<PostageType> onPostageTypeChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusSm),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
                  itemCount == 1
                      ? 'one_item'.tr()
<<<<<<< HEAD
                      : 'items_count'.tr(args: [itemCount.toString()]),
=======
                      : 'items_count'.tr(args: <String>[itemCount.toString()]),
>>>>>>> e947def20999a92448313553bb695b63691bc934
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          CheckoutDeliveryPickupToggle(
            onChanged: onPostageTypeChanged,
            value: postageType,
            isLoading: false,
            showText: true,
          ),
        ],
      ),
    );
  }
}
