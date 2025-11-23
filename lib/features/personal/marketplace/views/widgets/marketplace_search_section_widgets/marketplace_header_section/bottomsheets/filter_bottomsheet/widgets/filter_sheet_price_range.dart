import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../providers/marketplace_provider.dart';

class ExpandablePriceRangeTile extends StatefulWidget {
  const ExpandablePriceRangeTile({super.key});

  @override
  State<ExpandablePriceRangeTile> createState() =>
      _ExpandablePriceRangeTileState();
}

class _ExpandablePriceRangeTileState extends State<ExpandablePriceRangeTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          title: Text(
            'price'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            !_isExpanded ? 'select_price_range'.tr() : '',
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(color: ColorScheme.of(context).outline),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: marketPro.minPriceController,
                    keyboardType: TextInputType.number,
                    labelText: 'min_price'.tr(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    controller: marketPro.maxPriceController,
                    keyboardType: TextInputType.number,
                    labelText: 'max_price'.tr(),
                  ),
                ),
              ],
            ),
          ),
        if (_isExpanded) const SizedBox(height: 16),
      ],
    );
  }
}
