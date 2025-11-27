import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterPetsCategoryAndLocationWidget extends StatelessWidget {
  const MarketFilterPetsCategoryAndLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🟩 Get pets options from Local Hive Source
    final List<DropdownOptionEntity> petOptions =
        LocalCategoriesSource.pets ?? <DropdownOptionEntity>[];

    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider,
                  DropdownOptionEntity>(
                options: petOptions,
                valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                labelGetter: (DropdownOptionEntity opt) => opt.label,
                validator: (bool? p0) => null,
                hint: 'category'.tr(),
                selectedValue: marketPro.petCategory,
                onChanged: (String? p0) => marketPro.setPetCategory(p0),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: NominationLocationField(
                validator: (bool? p0) => null,
                selectedLatLng: marketPro.selectedlatlng,
                displayMode: MapDisplayMode.neverShowMap,
                initialText: marketPro.selectedLocation?.address ?? '',
                onLocationSelected: (LocationEntity p0, LatLng p1) {
                  marketPro.updateFilterContainerLocation(p1, p0);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
