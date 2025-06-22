import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterPropertyToggleWidget extends StatelessWidget {
  const MarketFilterPropertyToggleWidget({
    required this.screenWidth,
    super.key,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    final List<String> subCategories =
        ListingType.property.cids.getRange(0, 2).toList();
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: ColorScheme.of(context).outline),
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: CustomToggleSwitch<String>(
                  verticalPadding: 6,
                  isShaded: false,
                  customWidths: <double>[
                    screenWidth * 0.39,
                    screenWidth * 0.39
                  ],
                  labels: subCategories,
                  labelStrs: subCategories.map((String e) => e.tr()).toList(),
                  labelText: '',
                  initialValue: marketPro.cLothFootCategory,
                  onToggle: marketPro.setClothFootCategory),
            ),
          ),
        ),
      ],
    );
  }
}
