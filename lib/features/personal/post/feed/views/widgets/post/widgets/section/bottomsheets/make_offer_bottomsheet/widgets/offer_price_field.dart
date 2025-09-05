import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/helper_functions/country_helper.dart';

class OfferPriceField extends StatelessWidget {
  const OfferPriceField({
    required this.currency,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String currency;
  final TextEditingController controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    CountryHelper.currencySymbolHelper(currency),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              IntrinsicWidth(
                child: TextField(
                  autofocus: true,
                  onChanged: onChanged,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hint: Text(
                      '0',
                      style: TextTheme.of(context).headlineSmall?.copyWith(
                            color: ColorScheme.of(context).outlineVariant,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: RichText(
          //     textAlign: TextAlign.center,
          //     text: TextSpan(
          //       style: theme.textTheme.labelSmall?.copyWith(
          //         color: theme.colorScheme.outline,
          //       ),
          //       children: <InlineSpan>[
          //         TextSpan(text: parts.first),
          //         TextSpan(
          //           text: 'per unit',
          //           style: theme.textTheme.labelSmall?.copyWith(
          //             fontWeight: FontWeight.bold,
          //             color: theme.colorScheme.outlineVariant,
          //           ),
          //         ),
          //         if (parts.length > 1) TextSpan(text: parts.last),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
