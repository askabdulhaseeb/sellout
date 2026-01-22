import 'package:flutter/material.dart';

class CartDeliveryPickupToggle extends StatefulWidget {
  const CartDeliveryPickupToggle({super.key});

  @override
  State<CartDeliveryPickupToggle> createState() =>
      _CartDeliveryPickupToggleState();
}

class _CartDeliveryPickupToggleState extends State<CartDeliveryPickupToggle> {
  bool showText = true;
  bool isDeliveryLoading = false;
  bool isPickupLoading = false;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    final Color unselectedColor = Colors.grey;
    final double iconSize = 16;
    final double textSize = 12;
    final double buttonPaddingH = 8;
    final double buttonPaddingV = 4;
    final double borderRadius = 7;
    final double spacing = 3;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // DELIVERY
          GestureDetector(
            onTap: () async {
              setState(() {
                isDeliveryLoading = true;
                isPickupLoading = false;
              });
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                isDeliveryLoading = false;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: buttonPaddingH,
                vertical: buttonPaddingV,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isDeliveryLoading
                      ? selectedColor
                      : Colors.grey.shade300,
                  width: 1.1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  isDeliveryLoading
                      ? SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: selectedColor,
                          ),
                        )
                      : Icon(
                          Icons.local_shipping,
                          color: isDeliveryLoading
                              ? selectedColor
                              : unselectedColor,
                          size: iconSize,
                        ),
                  if (showText) ...<Widget>[
                    SizedBox(width: spacing),
                    Text(
                      'Delivery',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textSize,
                        color: isDeliveryLoading
                            ? selectedColor
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
            onTap: () async {
              setState(() {
                isPickupLoading = true;
                isDeliveryLoading = false;
              });
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                isPickupLoading = false;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: buttonPaddingH,
                vertical: buttonPaddingV,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isPickupLoading ? selectedColor : Colors.grey.shade300,
                  width: 1.1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  isPickupLoading
                      ? SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: selectedColor,
                          ),
                        )
                      : Icon(
                          Icons.store,
                          color: isPickupLoading
                              ? selectedColor
                              : unselectedColor,
                          size: iconSize,
                        ),
                  if (showText) ...<Widget>[
                    SizedBox(width: spacing),
                    Text(
                      'Pickup',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textSize,
                        color: isPickupLoading
                            ? selectedColor
                            : unselectedColor,
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
