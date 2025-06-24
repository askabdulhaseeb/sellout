import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../providers/add_listing_form_provider.dart';
import '../location_by_name_field.dart';
import '../custom_listing_dropdown.dart';

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomListingDropDown(
                    hint: 'age',
                    categoryKey: 'age',
                    selectedValue: formPro.age,
                    title: 'age'.tr(),
                    onChanged: formPro.setAge,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomListingDropDown(
                    hint: 'ready_to_leave',
                    categoryKey: 'ready_to_leave',
                    selectedValue: formPro.time,
                    title: 'ready_to_leave'.tr(),
                    onChanged: formPro.setTime,
                  ),
                ),
              ],
            ),
            CustomListingDropDown(
                title: 'category',
                hint: 'select_category',
                categoryKey: 'pets',
                selectedValue: formPro.petCategory,
                onChanged: (String? p0) => formPro.setPetCategory(p0)),
            CustomListingDropDown(
                parentValue: formPro.petCategory,
                title: 'breed',
                hint: 'breed',
                categoryKey: 'breed',
                selectedValue: formPro.breed,
                onChanged: (String? p0) => formPro.setPetBreed(p0)),
            LocationInputField(
              onLocationSelected: formPro.setMeetupLocation,
              initialLocation: formPro.selectedmeetupLocation,
            ),
            CustomDropdown<bool>(
              height: 50,
              selectedItem: formPro.vaccinationUpToDate,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('yes'.tr(), style: textStyle),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('no'.tr(), style: textStyle),
                ),
              ],
              onChanged: formPro.setVaccinationUpToDate,
              validator: (_) =>
                  formPro.vaccinationUpToDate == null ? 'required'.tr() : null,
              title: 'vaccination_up_to_date'.tr(),
            ),
            CustomDropdown<bool>(
              height: 50,
              selectedItem: formPro.wormAndFleaTreated,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('yes'.tr(), style: textStyle),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('no'.tr(), style: textStyle),
                ),
              ],
              onChanged: formPro.setWormFleeTreated,
              validator: (_) =>
                  formPro.wormAndFleaTreated == null ? 'required'.tr() : null,
              title: 'worm_flee_treated'.tr(),
            ),
            CustomDropdown<bool>(
              height: 50,
              padding: const EdgeInsets.all(0),
              selectedItem: formPro.healthChecked,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('yes'.tr(), style: textStyle),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('no'.tr(), style: textStyle),
                ),
              ],
              onChanged: formPro.setHealthChecked,
              validator: (_) =>
                  formPro.healthChecked == null ? 'required'.tr() : null,
              title: 'health_checked'.tr(),
            ),
          ],
        );
      },
    );
  }
}
