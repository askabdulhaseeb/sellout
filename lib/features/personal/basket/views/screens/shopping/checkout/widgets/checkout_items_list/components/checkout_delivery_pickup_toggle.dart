import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/enums/listing/core/postage_type.dart';
import 'checkout_delivery_pickup_style.dart';

class CheckoutDeliveryPickupToggle extends StatelessWidget {
  const CheckoutDeliveryPickupToggle({
    required this.onChanged,
    this.value = PostageType.postageOnly,
    this.isLoading = false,
    this.showText = true,
    super.key,
  });

  final PostageType value;
  final ValueChanged<PostageType> onChanged;
  final bool isLoading;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = ColorScheme.of(
      context,
    ).onSurface.withValues(alpha: 0.6);

    final bool isDeliverySelected = value == PostageType.postageOnly;
    final bool isPickupSelected = value == PostageType.pickupOnly;
    final bool isDeliveryLoading = isLoading && isDeliverySelected;
    final bool isPickupLoading = isLoading && isPickupSelected;

    return Container(
      padding: const EdgeInsets.all(
        CheckoutDeliveryPickupStyle.containerPadding,
      ),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).outline,
        border: Border.all(
          color: ColorScheme.of(context).outline,
          width: CheckoutDeliveryPickupStyle.borderWidth,
        ),
        borderRadius: BorderRadius.circular(
          CheckoutDeliveryPickupStyle.containerBorderRadius,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // DELIVERY BUTTON
          _DeliveryButton(
            isSelected: isDeliverySelected,
            isLoading: isDeliveryLoading,
            isDisabled: isLoading,
            unselectedColor: unselectedColor,
            showText: showText,
            onTap: isLoading ? null : () => onChanged(PostageType.postageOnly),
          ),
          SizedBox(width: CheckoutDeliveryPickupStyle.spacing),
          // PICKUP BUTTON
          _PickupButton(
            isSelected: isPickupSelected,
            isLoading: isPickupLoading,
            isDisabled: isLoading,
            unselectedColor: unselectedColor,
            showText: showText,
            onTap: isLoading ? null : () => onChanged(PostageType.pickupOnly),
          ),
        ],
      ),
    );
  }
}

/// Delivery button component
class _DeliveryButton extends StatelessWidget {
  const _DeliveryButton({
    required this.isSelected,
    required this.isLoading,
    required this.isDisabled,
    required this.unselectedColor,
    required this.showText,
    required this.onTap,
  });

  final bool isSelected;
  final bool isLoading;
  final bool isDisabled;
  final Color unselectedColor;
  final bool showText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CheckoutDeliveryPickupStyle.buttonPaddingH,
            vertical: CheckoutDeliveryPickupStyle.buttonPaddingV,
          ),
          decoration: BoxDecoration(
            color: isSelected || isLoading
                ? ColorScheme.of(context).surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              CheckoutDeliveryPickupStyle.borderRadius,
            ),
            boxShadow: isSelected || isLoading
                ? <BoxShadow>[CheckoutDeliveryPickupStyle.deliveryShadow()]
                : <BoxShadow>[],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              isLoading
                  ? SizedBox(
                      height: CheckoutDeliveryPickupStyle.iconSize,
                      width: CheckoutDeliveryPickupStyle.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CheckoutDeliveryPickupStyle.deliveryColor,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.local_shipping,
                      color: isSelected || isLoading
                          ? CheckoutDeliveryPickupStyle.deliveryColor
                          : unselectedColor,
                      size: CheckoutDeliveryPickupStyle.iconSize,
                    ),
              if (showText) ...<Widget>[
                SizedBox(width: CheckoutDeliveryPickupStyle.spacing),
                Text(
                  'delivery'.tr(),
                  style: TextStyle(
                    fontWeight: CheckoutDeliveryPickupStyle.buttonFontWeight,
                    fontSize: CheckoutDeliveryPickupStyle.textSize,
                    color: isSelected || isLoading
                        ? CheckoutDeliveryPickupStyle.deliveryColor
                        : unselectedColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Pickup button component
class _PickupButton extends StatelessWidget {
  const _PickupButton({
    required this.isSelected,
    required this.isLoading,
    required this.isDisabled,
    required this.unselectedColor,
    required this.showText,
    required this.onTap,
  });

  final bool isSelected;
  final bool isLoading;
  final bool isDisabled;
  final Color unselectedColor;
  final bool showText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CheckoutDeliveryPickupStyle.buttonPaddingH,
            vertical: CheckoutDeliveryPickupStyle.buttonPaddingV,
          ),
          decoration: BoxDecoration(
            color: isSelected || isLoading ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(
              CheckoutDeliveryPickupStyle.borderRadius,
            ),
            boxShadow: isSelected || isLoading
                ? <BoxShadow>[CheckoutDeliveryPickupStyle.pickupShadow()]
                : <BoxShadow>[],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              isLoading
                  ? SizedBox(
                      height: CheckoutDeliveryPickupStyle.iconSize,
                      width: CheckoutDeliveryPickupStyle.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CheckoutDeliveryPickupStyle.pickupColor,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.location_on_outlined,
                      color: isSelected || isLoading
                          ? CheckoutDeliveryPickupStyle.pickupColor
                          : unselectedColor,
                      size: CheckoutDeliveryPickupStyle.iconSize,
                    ),
              if (showText) ...<Widget>[
                SizedBox(width: CheckoutDeliveryPickupStyle.spacing),
                Text(
                  'pickup'.tr(),
                  style: TextStyle(
                    fontWeight: CheckoutDeliveryPickupStyle.buttonFontWeight,
                    fontSize: CheckoutDeliveryPickupStyle.textSize,
                    color: isSelected || isLoading
                        ? CheckoutDeliveryPickupStyle.pickupColor
                        : unselectedColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
