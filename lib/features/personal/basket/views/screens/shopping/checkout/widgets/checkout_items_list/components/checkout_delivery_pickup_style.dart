import 'package:flutter/material.dart';

/// Constants and styling for CheckoutDeliveryPickupToggle widget
class CheckoutDeliveryPickupStyle {
  // Colors
  static const Color deliveryColor = Color(0xFF2196F3);
  static const Color pickupColor = Color(0xFF4CAF50);

  // Sizes
  static const double iconSize = 16;
  static const double textSize = 12;
  static const double buttonPaddingH = 12;
  static const double buttonPaddingV = 6;
  static const double borderRadius = 7;
  static const double containerBorderRadius = 8;
  static const double spacing = 3;
  static const double containerPadding = 2;
  static const double borderWidth = 1.2;
  static const double shadowBlurRadius = 4;
  static const double shadowOpacity = 0.15;

  // Typography
  static const FontWeight buttonFontWeight = FontWeight.w500;

  static BoxShadow deliveryShadow() {
    return BoxShadow(
      color: deliveryColor.withValues(alpha: shadowOpacity),
      blurRadius: shadowBlurRadius,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow pickupShadow() {
    return BoxShadow(
      color: pickupColor.withValues(alpha: shadowOpacity),
      blurRadius: shadowBlurRadius,
      offset: const Offset(0, 2),
    );
  }
}
