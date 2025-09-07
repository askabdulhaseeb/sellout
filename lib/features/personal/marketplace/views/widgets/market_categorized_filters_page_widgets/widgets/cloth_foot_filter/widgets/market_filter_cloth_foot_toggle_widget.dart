import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterClothFootToggleWidget extends StatelessWidget {
  const MarketFilterClothFootToggleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> subCategories =
        ListingType.clothAndFoot.cids.getRange(0, 2).toList();
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
                    verticalMargin: 4,
                    horizontalMargin: 4,
                    containerHeight: 40,
                    verticalPadding: 8,
                    unseletedBorderColor: Colors.transparent,
                    isShaded: false,
                    labels: subCategories,
                    labelStrs: subCategories.map((String e) => e.tr()).toList(),
                    labelText: '',
                    initialValue: marketPro.cLothFootCategory,
                    onToggle: (String p0) =>
                        marketPro.setClothFootCategory(p0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
