import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/enums/listing/pet/age_time_type.dart';
import '../../../../../../../core/enums/listing/pet/pet_categories.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../providers/add_listing_form_provider.dart';
import '../location_by_name_field.dart';

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AgeTimeType> age = AgeTimeType.age;
    final List<AgeTimeType> time = AgeTimeType.time;
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<AgeTimeType>(
                    selectedItem: formPro.age,
                    items: age.map((AgeTimeType value) {
                      return DropdownMenuItem<AgeTimeType>(
                        value: value,
                        child: Text(value.title),
                      );
                    }).toList(),
                    onChanged: formPro.setAge,
                    validator: (_) =>
                        formPro.age == null ? 'Age is required' : null,
                    title: 'age'.tr(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDropdown<AgeTimeType>(
                    selectedItem: formPro.time,
                    items: time.map((AgeTimeType value) {
                      return DropdownMenuItem<AgeTimeType>(
                        value: value,
                        child: Text(value.title),
                      );
                    }).toList(),
                    onChanged: formPro.setTime,
                    validator: (_) =>
                        formPro.time == null ? 'Time is required' : null,
                    title: 'ready_to_leave'.tr(),
                  ),
                ),
              ],
            ),
            CustomDropdown<PetCategory>(
              selectedItem: formPro.petCategory,
              items: PetCategory.values.map((PetCategory value) {
                return DropdownMenuItem<PetCategory>(
                  value: value,
                  child: Text(value.title),
                );
              }).toList(),
              onChanged: formPro.setPetCategory,
              validator: (_) => formPro.petCategory == null
                  ? 'Pet category is required'
                  : null,
              title: 'pet_category'.tr(),
            ),
            const LocationInputField(),
            CustomTextFormField(
              controller: formPro.breed,
              labelText: 'breed',
            ),
            CustomDropdown<bool>(
              selectedItem: formPro.vaccinationUpToDate,
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
              ],
              onChanged: formPro.setVaccinationUpToDate,
              validator: (_) =>
                  formPro.vaccinationUpToDate == null ? 'Required' : null,
              title: 'vaccination_up_to_date'.tr(),
            ),
            CustomDropdown<bool>(
              selectedItem: formPro.wormAndFleaTreated,
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
              ],
              onChanged: formPro.setWormFleeTreated,
              validator: (_) =>
                  formPro.wormAndFleaTreated == null ? 'Required' : null,
              title: 'worm_flee_treated'.tr(),
            ),
            CustomDropdown<bool>(
              selectedItem: formPro.healthChecked,
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
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
