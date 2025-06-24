import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/custom_listing_dropdown.dart';
import '../../widgets/vehicle/add_listing_vehicle_basic_info_section.dart';
import '../../widgets/vehicle/add_listing_vehicle_ternsmission_engine_mileage_section.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => _loadDropdowns());
  }

  Future<void> _loadDropdowns() async {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    await formPro.fetchDropdownListings(
        '/category/${formPro.listingType?.json}?list-id=');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        if (formPro.isDropdownLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Form(
          key: formPro.vehicleKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: <Widget>[
              const AddListingBasicInfoSection(),
              CustomListingDropDown(
                  title: 'category',
                  categoryKey: 'vehicles',
                  hint: 'select_category',
                  selectedValue: formPro.selectedVehicleCategory,
                  onChanged: (String? p0) => formPro.setVehicleCategory(p0)),
              // SubCategorySelectableWidget(
              //   listType: formPro.listingType,
              //   subCategory: formPro.selectedCategory,
              //   onSelected: formPro.setSelectedCategory,
              // ),
              const AddListingVehicleBasicInfoSection(),
              const AddListingVehicleTernsmissionEngineMileageSection(),
              const AddListingConditionOfferSection(),
              const EditableAvailabilityWidget(),
              if (formPro.post == null) const AddListingPostButtonWidget(),
              if (formPro.post != null) const AddListingUpdateButtons(),
            ],
          ),
        );
      },
    );
  }
}
