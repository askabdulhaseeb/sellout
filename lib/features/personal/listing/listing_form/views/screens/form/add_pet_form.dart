import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/pet/add_listing_age_leave_section.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_delivery_selection_widget.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/add_listing_price_and_quantity_widget.dart';

class AddPetForm extends StatelessWidget {
  const AddPetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
        builder: (BuildContext context, AddListingFormProvider formPro,
                Widget? child) =>
            Form(
              key: formPro.petKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: <Widget>[
                  const AddListingBasicInfoSection(),
                  const AddListingPetAgeLeaveWidget(),
                  SubCategorySelectableWidget(
                    listType: formPro.listingType,
                    subCategory: formPro.selectedCategory,
                    onSelected: formPro.setSelectedCategory,
                  ),
                  const AddListingPriceAndQuantityWidget(),
                  const AddListingConditionOfferSection(),
                  const AddListingDeliverySelectionWidget(),
                  const EditableAvailabilityWidget(),
                  const AddListingPostButtonWidget(),
                ],
              ),
            ));
  }
}
