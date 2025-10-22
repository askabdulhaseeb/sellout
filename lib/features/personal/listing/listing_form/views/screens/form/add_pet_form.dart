import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/pet/add_listing_age_leave_section.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/add_listing_price_and_quantity_widget.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {

        return Form(
          key: formPro.petKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: AppSpacing.vSm,
              children: <Widget>[
                const AddListingBasicInfoSection(),
                const AddListingPetAgeLeaveWidget(),
                const AddListingPriceAndQuantityWidget(),
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
