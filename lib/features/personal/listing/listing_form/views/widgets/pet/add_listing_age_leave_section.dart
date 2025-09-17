import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../../data/sources/local/local_categories.dart';
import '../custom_listing_dropdown.dart';

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Provide explicit option lists
    final List<DropdownOptionEntity> ageOptions =
        LocalCategoriesSource.age ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> readyToLeaveOptions =
        LocalCategoriesSource.readyToLeave ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> petCategories =
        LocalCategoriesSource.pets ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> breedOptions =
        LocalCategoriesSource.breed ?? <DropdownOptionEntity>[];

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            /// Age + Ready to leave
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomListingDropDown<AddListingFormProvider,
                      DropdownOptionEntity>(
                    options: ageOptions,
                    valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                    labelGetter: (DropdownOptionEntity opt) => opt.label,
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'age'.tr(),
                    selectedValue: formPro.age,
                    title: 'age'.tr(),
                    onChanged: (String? p0) => formPro.setAge(p0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomListingDropDown<AddListingFormProvider,
                      DropdownOptionEntity>(
                    options: readyToLeaveOptions,
                    valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                    labelGetter: (DropdownOptionEntity opt) => opt.label,
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'ready_to_leave'.tr(),
                    selectedValue: formPro.time,
                    title: 'ready_to_leave'.tr(),
                    onChanged: (String? p0) => formPro.setTime(p0),
                  ),
                ),
              ],
            ),

            /// Pet Category
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: petCategories,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'select_category'.tr(),
              selectedValue: formPro.petCategory,
              onChanged: (String? p0) => formPro.setPetCategory(p0),
              title: 'category'.tr(),
            ),

            /// Breed (shows only if a category is selected)
            if (formPro.petCategory != null)
              CustomListingDropDown<AddListingFormProvider,
                  DropdownOptionEntity>(
                options:
                    breedOptions, // could be filtered by petCategory if needed
                valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                labelGetter: (DropdownOptionEntity opt) => opt.label,
                validator: (bool? value) =>
                    AppValidator.requireSelection(value),
                hint: 'breed'.tr(),
                selectedValue: formPro.breed,
                onChanged: (String? p0) => formPro.setPetBreed(p0),
                title: 'breed'.tr(),
              ),

            /// Location field
            NominationLocationField(
              validator: (bool? value) => AppValidator.requireLocation(value),
              title: 'meetup_location'.tr(),
              selectedLatLng: formPro.meetupLatLng,
              displayMode: MapDisplayMode.showMapAfterSelection,
              initialText: formPro.selectedmeetupLocation?.address ?? '',
              onLocationSelected: (LocationEntity p0, LatLng p1) =>
                  formPro.setMeetupLocation(p0, p1),
            ),
          ],
        );
      },
    );
  }
}
