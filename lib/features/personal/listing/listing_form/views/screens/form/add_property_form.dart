import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/property/add_listing_property_bed_bath_widget.dart';
import '../../widgets/property/add_property_gpa_widget.dart';

class AddPropertyForm extends StatefulWidget {
  const AddPropertyForm({super.key});

  @override
  State<AddPropertyForm> createState() => _AddPropertyFormState();
}

class _AddPropertyFormState extends State<AddPropertyForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        if (formPro.isDropdownLoading) {
          return const Center(
            child: Loader(),
          );
        }
        return Form(
          key: formPro.propertyKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: AppSpacing.vXs,
              children: <Widget>[
                const AddListingBasicInfoSection(),
                const AddListingPropertyBedBathWidget(),
                const AddPropertyGPAWidget(),
                const AddListingConditionOfferSection(),
                const EditableAvailabilityWidget(),
                if (formPro.post == null) const AddListingPostButtonWidget(),
                if (formPro.post != null) const AddListingUpdateButtons(),
              ],
            ),
          ),
        );
      },
    );
  }
}
