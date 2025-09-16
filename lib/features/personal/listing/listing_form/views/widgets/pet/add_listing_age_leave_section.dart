import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomListingDropDown<AddListingFormProvider>(
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'age'.tr(),
                    categoryKey: 'age',
                    selectedValue: formPro.age,
                    title: 'age'.tr(),
                    onChanged: (String? p0) => formPro.setAge(p0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomListingDropDown<AddListingFormProvider>(
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'ready_to_leave'.tr(),
                    categoryKey: 'ready_to_leave',
                    selectedValue: formPro.time,
                    title: 'ready_to_leave'.tr(),
                    onChanged: (String? p0) => formPro.setTime(p0),
                  ),
                ),
              ],
            ),
            CustomListingDropDown<AddListingFormProvider>(
                validator: (bool? value) =>
                    AppValidator.requireSelection(value),
                title: 'category'.tr(),
                hint: 'select_category'.tr(),
                categoryKey: 'pets',
                selectedValue: formPro.petCategory,
                onChanged: (String? p0) => formPro.setPetCategory(p0)),
            if (formPro.petCategory != null)
              CustomListingDropDown<AddListingFormProvider>(
                  validator: (bool? value) =>
                      AppValidator.requireSelection(value),
                  parentValue: formPro.petCategory,
                  title: 'breed'.tr(),
                  hint: 'breed'.tr(),
                  categoryKey: 'breed',
                  selectedValue: formPro.breed,
                  onChanged: (String? p0) => formPro.setPetBreed(p0)),
            NominationLocationField(
                validator: (bool? value) => AppValidator.requireLocation(value),
                title: 'meetup_location'.tr(),
                selectedLatLng: formPro.meetupLatLng,
                displayMode: MapDisplayMode.showMapAfterSelection,
                initialText: formPro.selectedmeetupLocation?.address ?? '',
                onLocationSelected: (LocationEntity p0, LatLng p1) =>
                    formPro.setMeetupLocation(p0, p1)),
            // buildYesNoDropdown(
            //     title: 'vaccination_up_to_date'.tr(),
            //     selectedValue: formPro.vaccinationUpToDate,
            //     onChanged: (bool? p0) => formPro.setVaccinationUpToDate(p0),
            //     textStyle: textStyle),
            // buildYesNoDropdown(
            //     title: 'worm_flee_treated'.tr(),
            //     selectedValue: formPro.wormAndFleaTreated,
            //     onChanged: (bool? p0) => formPro.setWormFleeTreated(p0),
            //     textStyle: textStyle),
            // buildYesNoDropdown(
            //   title: 'health_checked'.tr(),
            //   selectedValue: formPro.healthChecked,
            //   onChanged: (bool? p0) => formPro.setHealthChecked(p0),
            //   textStyle: textStyle,
            // ),
          ],
        );
      },
    );
  }

  Widget buildYesNoDropdown({
    required String title,
    required bool? selectedValue,
    required Function(bool?) onChanged,
    required TextStyle? textStyle,
  }) {
    return CustomDropdown<bool>(
      selectedItem: selectedValue,
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
      onChanged: onChanged,
      validator: (bool? val) => AppValidator.requireSelection(val),
      title: title,
    );
  }
}
