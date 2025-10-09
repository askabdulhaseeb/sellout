import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../domain/entities/category_entites/subentities/parent_dropdown_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../../data/sources/local/local_categories.dart';

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionEntity> ageOptions =
        LocalCategoriesSource.age ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> readyToLeaveOptions =
        LocalCategoriesSource.readyToLeave ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> petCategories =
        LocalCategoriesSource.pets ?? <DropdownOptionEntity>[];
    final List<ParentDropdownEntity> breedOptions =
        LocalCategoriesSource.breed ?? <ParentDropdownEntity>[];

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        // Breed list safely
        final ParentDropdownEntity? matchedBreed = breedOptions
            .where(
                (ParentDropdownEntity p) => p.category == formPro.petCategory)
            .cast<ParentDropdownEntity?>()
            .firstOrNull;
        final List<DropdownOptionEntity> breedList =
            matchedBreed?.options ?? <DropdownOptionEntity>[];

        return Column(
          spacing: AppSpacing.vXs,
          children: <Widget>[
            /// Age + Ready to leave
            Row(
              spacing: AppSpacing.hXs,
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<DropdownOptionEntity>(
                    items: ageOptions
                        .map(
                          (DropdownOptionEntity opt) =>
                              DropdownMenuItem<DropdownOptionEntity>(
                            value: opt,
                            child: Text(opt.label),
                          ),
                        )
                        .toList(),
                    selectedItem: DropdownOptionEntity.findByValue(
                      ageOptions,
                      formPro.age ?? '',
                    ),
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'age'.tr(),
                    title: 'age'.tr(),
                    onChanged: (DropdownOptionEntity? value) =>
                        formPro.setAge(value?.value.value),
                  ),
                ),
                Expanded(
                  child: CustomDropdown<DropdownOptionEntity>(
                    items: readyToLeaveOptions
                        .map(
                          (DropdownOptionEntity opt) =>
                              DropdownMenuItem<DropdownOptionEntity>(
                            value: opt,
                            child: Text(opt.label),
                          ),
                        )
                        .toList(),
                    selectedItem: DropdownOptionEntity.findByValue(
                      readyToLeaveOptions,
                      formPro.time ?? '',
                    ),
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'ready_to_leave'.tr(),
                    title: 'ready_to_leave'.tr(),
                    onChanged: (DropdownOptionEntity? value) =>
                        formPro.setTime(value?.value.value),
                  ),
                ),
              ],
            ),

            /// Pet Category
            CustomDropdown<DropdownOptionEntity>(
              items: petCategories
                  .map(
                    (DropdownOptionEntity opt) =>
                        DropdownMenuItem<DropdownOptionEntity>(
                      value: opt,
                      child: Text(opt.label),
                    ),
                  )
                  .toList(),
              selectedItem: DropdownOptionEntity.findByValue(
                petCategories,
                formPro.petCategory ?? '',
              ),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'select_category'.tr(),
              title: 'category'.tr(),
              onChanged: (DropdownOptionEntity? value) =>
                  formPro.setPetCategory(value?.value.value),
            ),

            /// Breed dropdown (only if category selected)
            if (formPro.petCategory != null && formPro.petCategory!.isNotEmpty)
              CustomDropdown<DropdownOptionEntity>(
                items: breedList
                    .map(
                      (DropdownOptionEntity opt) =>
                          DropdownMenuItem<DropdownOptionEntity>(
                        value: opt,
                        child: Text(opt.label),
                      ),
                    )
                    .toList(),
                selectedItem: DropdownOptionEntity.findByValue(
                  breedList,
                  formPro.breed ?? '',
                ),
                validator: (bool? value) =>
                    AppValidator.requireSelection(value),
                hint: 'breed'.tr(),
                title: 'breed'.tr(),
                onChanged: (DropdownOptionEntity? value) =>
                    formPro.setPetBreed(value?.value.value),
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
