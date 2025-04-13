import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/vehicle/transmission_type.dart';
import '../../../../../../../core/enums/listing/vehicles/vehicle_category_type.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../providers/add_listing_form_provider.dart';
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
              spacing: 6,
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.mileage,
                    labelText: 'mileage'.tr(),
                    hint: 'Ex. 10000',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                    width: 100,
                    child: CustomDropdown<String>(
                      title: 'mileage_unit'.tr(),
                      items: <String>['miles', 'KM']
                          .map((String unit) => DropdownMenuItem<String>(
                                value: unit,
                                child: Text(
                                  unit.tr(),
                                ),
                              ))
                          .toList(),
                      selectedItem: formPro.selectedMileageUnit,
                      height: 45,
                      onChanged: formPro.setMileageUnit,
                      validator: (_) => formPro.selectedMileageUnit == null
                          ? 'Required'
                          : null,
                    )),
              ],
            ),
            CustomDropdown<VehicleCategoryType>(
              title: 'Vehicle Category',
              items: VehicleCategoryType.values.map((VehicleCategoryType e) {
                return DropdownMenuItem<VehicleCategoryType>(
                  value: e,
                  child: Text(e.label),
                );
              }).toList(),
              selectedItem: formPro.selectedVehicleCategory,
              onChanged: formPro.setVehicleCategory,
              validator: (_) => formPro.selectedCategory == null
                  ? 'Category is required'
                  : null,
            ),
            CustomTextFormField(
              controller: formPro.doors,
              labelText: 'doors'.tr(),
              hint: 'Ex. 10000',
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              controller: formPro.seats,
              labelText: 'seats'.tr(),
              hint: 'Ex. 10000',
              keyboardType: TextInputType.number,
            ),
            const LocationInputField(),
            CustomToggleSwitch<TransmissionType>(
              labels: TransmissionType.list,
              labelStrs: TransmissionType.list
                  .map((TransmissionType e) => e.title)
                  .toList(),
              labelText: 'Transmission',
              onToggle: formPro.setTransmissionType,
              initialValue: formPro.transmissionType,
            )
          ],
        );
      },
    );
  }
}
