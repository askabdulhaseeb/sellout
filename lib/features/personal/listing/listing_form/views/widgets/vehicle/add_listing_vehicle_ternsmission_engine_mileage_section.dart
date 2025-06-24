import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../location/data/models/location_model.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';
import '../location_by_name_field.dart';

class AddListingVehicleTernsmissionEngineMileageSection
    extends StatelessWidget {
  const AddListingVehicleTernsmissionEngineMileageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              controller: formPro.engineSize,
              labelText: 'Engine Size',
              hint: 'Ex. 1.6',
              keyboardType: TextInputType.number,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.mileage,
                    labelText: 'mileage'.tr(),
                    hint: 'Ex. 10000',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomListingDropDown(
                    hint: 'mileage_unit',
                    categoryKey: 'mileage_unit',
                    selectedValue: formPro.selectedMileageUnit,
                    title: 'mileage_unit',
                    onChanged: formPro.setMileageUnit,
                  ),
                ),
              ],
            ),
            CustomListingDropDown(
              categoryKey: 'vehicles',
              selectedValue: formPro.selectedVehicleCategory,
              title: 'vehicle_category',
              onChanged: (String? val) {
                formPro.setVehicleCategory(val);
              },
            ),
            CustomTextFormField(
              controller: formPro.doors,
              labelText: 'doors'.tr(),
              hint: 'Ex. 4',
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              controller: formPro.seats,
              labelText: 'seats'.tr(),
              hint: 'Ex. 5',
              keyboardType: TextInputType.number,
            ),
            LocationInputField(
              onLocationSelected: (LocationModel location) {
                formPro.setMeetupLocation(location);
              },
              initialLocation: formPro.selectedmeetupLocation,
            ),
            // CustomToggleSwitch<TransmissionType>(
            //   labels: TransmissionType.list,
            //   labelStrs: TransmissionType.list.map((e) => e.title).toList(),
            //   labelText: 'Transmission',
            //   onToggle: formPro.setTransmissionType,
            //   initialValue: formPro.transmissionType,
            // ),
          ],
        );
      },
    );
  }
}
