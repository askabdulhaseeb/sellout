import 'package:flutter/material.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';

/// A unified widget for displaying currency values consistently across message tiles.
/// Replaces duplicated currency formatting in offer, quote, visiting, and inquiry tiles.
class CurrencyDisplay extends StatelessWidget {
  const CurrencyDisplay({
    required this.currency,
    required this.price,
    this.style,
    this.strikethrough = false,
    this.prefix,
    this.suffix,
    super.key,
  });

  /// Currency code (e.g., 'USD', 'PKR', 'GBP')
  final String? currency;

  /// The price value to display
  final dynamic price;

  /// Optional text style. If not provided, uses default styling
  final TextStyle? style;

  /// Whether to show the price with strikethrough decoration
  final bool strikethrough;

  /// Optional prefix text (e.g., 'Price: ')
  final String? prefix;

  /// Optional suffix text (e.g., ' /item')
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(currency);
    final String priceText = price?.toString() ?? '';

    // Show fallback text if price is empty
    if (priceText.isEmpty) {
      return Text('—', style: style);
    }

    final String displayText =
        '${prefix ?? ''}$symbol $priceText${suffix ?? ''}';

    final TextStyle effectiveStyle = (style ?? const TextStyle()).copyWith(
      decoration: strikethrough ? TextDecoration.lineThrough : null,
    );

    return Text(displayText, style: effectiveStyle);
  }
}

/// A widget that displays both offer price and original price together.
class CurrencyDisplayWithOriginal extends StatelessWidget {
  const CurrencyDisplayWithOriginal({
    required this.currency,
    required this.offerPrice,
    required this.originalPrice,
    this.offerStyle,
    this.originalStyle,
    this.spacing = 4,
    super.key,
  });

  final String? currency;
  final dynamic offerPrice;
  final dynamic originalPrice;
  final TextStyle? offerStyle;
  final TextStyle? originalStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final String offerPriceText = offerPrice?.toString() ?? '';
    final String originalPriceText = originalPrice?.toString() ?? '';

    // Show fallback if both prices are empty
    if (offerPriceText.isEmpty && originalPriceText.isEmpty) {
      return Text('—', style: offerStyle);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CurrencyDisplay(
          currency: currency,
          price: offerPrice,
          style:
              offerStyle ??
              Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(width: spacing),
        CurrencyDisplay(
          currency: currency,
          price: originalPrice,
          strikethrough: true,
          style: originalStyle ?? Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
