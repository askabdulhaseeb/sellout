import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterVehicleCategoryAndModalWIdget extends StatelessWidget {
  const MarketFilterVehicleCategoryAndModalWIdget({
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
                  validator: (bool? p0) => null,
                  hint: 'category',
                  categoryKey: 'vehicles',
                  selectedValue: marketPro.vehicleCatgory,
                  onChanged: marketPro.setVehicleCategory)),
          Expanded(
            child: CustomTextFormField(
              controller: marketPro.vehicleModel,
              hint: 'model'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
