import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../location/data/models/location_model.dart';
import '../../providers/add_listing_form_provider.dart';
import '../location_by_name_field.dart';
import '../custom_listing_dropdown.dart'; // Assuming this contains CustomDynamicDropdown

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = TextTheme.of(context).bodyMedium;
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDynamicDropdown(
                    categoryKey: 'age',
                    selectedValue: formPro.age,
                    title: 'age'.tr(),
                    onChanged: (String? value) {
                      formPro.setAge(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDynamicDropdown(
                    categoryKey: 'ready_to_leave',
                    selectedValue: formPro.time,
                    title: 'ready_to_leave'.tr(),
                    onChanged: (String? value) {
                      formPro.setTime(value);
                    },
                  ),
                ),
              ],
            ),
            CustomDynamicDropdown(
              categoryKey: 'breed',
              selectedValue: formPro.breed,
              title: 'breed'.tr(),
              onChanged: (String? value) {},
            ),
            LocationInputField(
              onLocationSelected: (LocationModel location) {
                formPro.setMeetupLocation(location);
              },
              initialLocation: formPro.selectedmeetupLocation,
            ),
            CustomDropdown<bool>(
              selectedItem: formPro.vaccinationUpToDate,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                    value: true, child: Text('Yes', style: textStyle)),
                DropdownMenuItem<bool>(
                    value: false, child: Text('No', style: textStyle)),
              ],
              onChanged: formPro.setVaccinationUpToDate,
              validator: (_) =>
                  formPro.vaccinationUpToDate == null ? 'Required' : null,
              title: 'vaccination_up_to_date'.tr(),
            ),
            CustomDropdown<bool>(
              selectedItem: formPro.wormAndFleaTreated,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                    value: true, child: Text('Yes', style: textStyle)),
                DropdownMenuItem<bool>(
                    value: false, child: Text('No', style: textStyle)),
              ],
              onChanged: formPro.setWormFleeTreated,
              validator: (_) =>
                  formPro.wormAndFleaTreated == null ? 'Required' : null,
              title: 'worm_flee_treated'.tr(),
            ),
            CustomDropdown<bool>(
              selectedItem: formPro.healthChecked,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                    value: true, child: Text('Yes', style: textStyle)),
                DropdownMenuItem<bool>(
                    value: false, child: Text('No', style: textStyle)),
              ],
              onChanged: formPro.setHealthChecked,
              validator: (_) =>
                  formPro.healthChecked == null ? 'Required' : null,
              title: 'health_checked'.tr(),
            ),
          ],
        );
      },
    );
  }
}
