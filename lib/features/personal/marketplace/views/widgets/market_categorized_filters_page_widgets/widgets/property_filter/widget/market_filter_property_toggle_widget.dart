import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterPropertyToggleWidget extends StatelessWidget {
  const MarketFilterPropertyToggleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> subCategories =
        ListingType.property.cids.getRange(0, 2).toList();
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro,
              Widget? child) =>
          Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: ColorScheme.of(context).outlineVariant),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CustomToggleSwitch<String>(
                    unseletedBorderColor: Colors.transparent,
                    isShaded: false,
                    verticalMargin: 4,
                    horizontalMargin: 4,
                    containerHeight: 40,
                    verticalPadding: 8,
                    labels: subCategories,
                    labelStrs: subCategories.map((String e) => e.tr()).toList(),
                    labelText: '',
                    initialValue: marketPro.propertyCategory,
                    onToggle: (String p0) => marketPro.setProperyyCategory(p0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
