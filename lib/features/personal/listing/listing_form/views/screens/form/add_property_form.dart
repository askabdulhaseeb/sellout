import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/property/add_listing_property_bed_bath_widget.dart';
import '../../widgets/property/add_listing_property_subcat_selection_section.dart';
import '../../widgets/property/add_property_gpa_widget.dart';

class AddPropertyForm extends StatelessWidget {
  const AddPropertyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro,
          Widget? child) {
        return Form(
          key: Provider.of<AddListingFormProvider>(context).propertyKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: <Widget>[
              const AddListingBasicInfoSection(),
              const AddListingPropertySubcatSelectionSection(),
              SubCategorySelectableWidget(
                listType: formPro.listingType,
                subCategory: formPro.selectedCategory,
                onSelected: formPro.setSelectedCategory,
              ),
              const AddListingPropertyBedBathWidget(),
              const AddPropertyGPAWidget(),
              const AddListingConditionOfferSection(),
              const EditableAvailabilityWidget(),
              if (formPro.post == null) const AddListingPostButtonWidget(),
              if (formPro.post != null) const AddListingUpdateButtons()
            ],
          ),
        );
      },
    );
  }
}
