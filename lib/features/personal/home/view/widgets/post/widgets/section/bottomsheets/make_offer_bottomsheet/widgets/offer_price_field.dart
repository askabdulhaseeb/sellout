import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/helper_functions/country_helper.dart';

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
          Text(
            'your_offer'.tr(),
            style: TextTheme.of(context)
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 120,
                child: TextField(
                  autofocus: true,
                  onChanged: onChanged,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    prefix: Text(
                      CountryHelper.currencySymbolHelper(currency),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    hintText: '0',
                    hintStyle: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.outlineVariant,
                      fontWeight: FontWeight.w700,
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
