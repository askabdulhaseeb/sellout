import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import '../../providers/add_listing_form_provider.dart';
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
                  child: CustomListingDropDown<AddListingFormProvider>(
                    validator: (bool? p0) => null,
                    hint: 'age'.tr(),
                    categoryKey: 'age',
                    selectedValue: formPro.age,
                    title: 'age'.tr(),
                    onChanged: formPro.setAge,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomListingDropDown<AddListingFormProvider>(
                    validator: (bool? p0) => null,
                    hint: 'ready_to_leave'.tr(),
                    categoryKey: 'ready_to_leave',
                    selectedValue: formPro.time,
                    title: 'ready_to_leave'.tr(),
                    onChanged: formPro.setTime,
                  ),
                ),
              ],
            ),
            CustomListingDropDown<AddListingFormProvider>(
                validator: (bool? p0) => null,
                title: 'category'.tr(),
                hint: 'select_category'.tr(),
                categoryKey: 'pets',
                selectedValue: formPro.petCategory,
                onChanged: (String? p0) => formPro.setPetCategory(p0)),
            if (formPro.petCategory != null)
              CustomListingDropDown<AddListingFormProvider>(
                  validator: (bool? p0) => null,
                  parentValue: formPro.petCategory,
                  title: 'breed'.tr(),
                  hint: 'breed'.tr(),
                  categoryKey: 'breed',
                  selectedValue: formPro.breed,
                  onChanged: (String? p0) => formPro.setPetBreed(p0)),
            NominationLocationField(
                title: 'meetup_location'.tr(),
                selectedLatLng: formPro.collectionLatLng,
                displayMode: MapDisplayMode.showMapAfterSelection,
                initialText: formPro.selectedmeetupLocation?.address ?? '',
                onLocationSelected: (LocationEntity p0, LatLng p1) =>
                    formPro.setMeetupLocation(p0, p1)),
            CustomDropdown<bool>(
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
