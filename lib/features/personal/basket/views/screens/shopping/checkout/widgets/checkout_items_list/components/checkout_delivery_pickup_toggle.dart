import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/enums/listing/core/postage_type.dart';

class CheckoutDeliveryPickupToggle extends StatelessWidget {
  const CheckoutDeliveryPickupToggle({
    required this.value,
    required this.onChanged,
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
    const Color deliveryColor = Color(0xFF2196F3);
    const Color pickupColor = Color(0xFF4CAF50);
    final Color unselectedColor = ColorScheme.of(
      context,
    ).onSurface.withValues(alpha: 0.6);
    final double iconSize = 16;
    final double textSize = 12;
    final double buttonPaddingH = 12;
    final double buttonPaddingV = 6;
    final double borderRadius = 7;
    final double spacing = 3;

    final bool isDeliverySelected = value == PostageType.postageOnly;
    final bool isPickupSelected = value == PostageType.pickupOnly;
    final bool isDeliveryLoading = isLoading && isDeliverySelected;
    final bool isPickupLoading = isLoading && isPickupSelected;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).outline,
        border: Border.all(color: ColorScheme.of(context).outline, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // DELIVERY
          GestureDetector(
            onTap: isLoading ? null : () => onChanged(PostageType.postageOnly),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: buttonPaddingH,
                vertical: buttonPaddingV,
              ),
              decoration: BoxDecoration(
                color: isDeliveryLoading
                    ? ColorScheme.of(context).surface
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: isDeliveryLoading
                    ? <BoxShadow>[
                        BoxShadow(
                          color: deliveryColor.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : <BoxShadow>[],
              ),
              child: Row(
                children: <Widget>[
                  isDeliveryLoading
                      ? SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: deliveryColor,
                          ),
                        )
                      : Icon(
                          Icons.local_shipping,
                          color: isDeliveryLoading
                              ? deliveryColor
                              : unselectedColor,
                          size: iconSize,
                        ),
                  if (showText) ...<Widget>[
                    SizedBox(width: spacing),
                    Text(
                      'delivery'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textSize,
                        color: isDeliveryLoading
                            ? deliveryColor
                            : unselectedColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(width: spacing),
          // PICKUP
          GestureDetector(
            onTap: isLoading ? null : () => onChanged(PostageType.pickupOnly),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: buttonPaddingH,
                vertical: buttonPaddingV,
              ),
              decoration: BoxDecoration(
                color: isPickupLoading ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: isPickupLoading
                    ? <BoxShadow>[
                        BoxShadow(
                          color: pickupColor.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : <BoxShadow>[],
              ),
              child: Row(
                children: <Widget>[
                  isPickupLoading
                      ? SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: pickupColor,
                          ),
                        )
                      : Icon(
                          Icons.store,
                          color: isPickupLoading
                              ? pickupColor
                              : unselectedColor,
                          size: iconSize,
                        ),
                  if (showText) ...<Widget>[
                    SizedBox(width: spacing),
                    Text(
                      'pickup'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textSize,
                        color: isPickupLoading ? pickupColor : unselectedColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
