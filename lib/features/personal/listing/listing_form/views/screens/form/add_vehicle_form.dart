import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/vehicle/add_listing_vehicle_basic_info_section.dart';
import '../../widgets/vehicle/add_listing_vehicle_transmission_engine_mileage_section.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
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
          key: formPro.vehicleKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const AddListingBasicInfoSection(),
                const AddListingVehicleBasicInfoSection(),
                const AddListingVehicleTernsmissionEngineMileageSection(),
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
