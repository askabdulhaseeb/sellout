import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterpetsCategoryAndLocationWIdget extends StatelessWidget {
  const MarketFilterpetsCategoryAndLocationWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
        builder: (BuildContext context, MarketPlaceProvider marketPro,
                Widget? child) =>
            Row(
              spacing: 4,
              children: <Widget>[
                Expanded(
                    child: CustomListingDropDown<MarketPlaceProvider>(
                        validator: (bool? p0) => null,
                        hint: 'category'.tr(),
                        categoryKey: 'pets',
                        selectedValue: marketPro.petCategory,
                        onChanged: (String? p0) =>
                            marketPro.setPetCategory(p0))),
                Expanded(
                  child: NominationLocationField(
                    selectedLatLng: marketPro.selectedlatlng,
                    displayMode: MapDisplayMode.neverShowMap,
                    initialText: marketPro.selectedLocation?.title ?? '',
                    onLocationSelected: (LocationEntity p0, LatLng p1) {
                      marketPro.updateLocation(p1, p0);
                    },
                  ),
                )
              ],
            ));
  }
}
