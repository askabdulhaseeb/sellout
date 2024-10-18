import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/add_listing_form_provider.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/vehicle/add_listing_vehicle_ternsmission_engine_mileage_section.dart';

class AddVehicleForm extends StatelessWidget {
  const AddVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
        builder: (BuildContext context, AddListingFormProvider formPro, _) {
      return Form(
        key: formPro.vehicleKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: <Widget>[
            const AddListingBasicInfoSection(),
            SubCategorySelectableWidget(
              listType: formPro.listingType,
              subCategory: formPro.selectedCategory,
              onSelected: formPro.setSelectedCategory,
            ),
            // TODO: Category selection widget
            const AddListingVehicleTernsmissionEngineMileageSection(),
            const AddListingConditionOfferSection(),
            const AddListingPostButtonWidget(),
          ],
        ),
      );
    });
  }
}
