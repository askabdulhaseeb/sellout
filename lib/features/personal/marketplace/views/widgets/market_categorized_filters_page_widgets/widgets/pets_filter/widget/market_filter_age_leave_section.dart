import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterAgeLeaveWidget extends StatelessWidget {
  const MarketFilterAgeLeaveWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro,
              Widget? child) =>
          Row(
        spacing: 4,
        children: <Widget>[
          Expanded(
            child: CustomListingDropDown<MarketPlaceProvider>(
              hint: 'age',
              categoryKey: 'age',
              selectedValue: marketPro.age,
              onChanged: (String? p0) => marketPro.setAge(p0),
            ),
          ),
          Expanded(
            child: CustomListingDropDown<MarketPlaceProvider>(
              hint: 'ready_to_leave',
              categoryKey: 'ready_to_leave',
              selectedValue: marketPro.readyToLeave,
              onChanged: (String? p0) => marketPro.setReadyToLeave(p0),
            ),
          ),
        ],
      ),
    );
  }
}
