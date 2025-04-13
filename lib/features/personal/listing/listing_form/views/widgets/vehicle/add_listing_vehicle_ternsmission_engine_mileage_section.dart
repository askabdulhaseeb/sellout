import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/vehicle/transmission_type.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
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
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.engineSize,
                    labelText: 'Engine Size',
                    hint: 'Ex. 1.6',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.mileage,
                    labelText: 'Mileage',
                    hint: 'Ex. 10000',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
            ),
          ],
        );
      },
    );
  }
}
