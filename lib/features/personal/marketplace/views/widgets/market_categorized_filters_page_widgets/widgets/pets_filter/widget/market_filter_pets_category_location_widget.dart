import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/location_field.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../domain/entities/location_name_entity.dart';
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
                        hint: 'category',
                        categoryKey: 'pets',
                        selectedValue: marketPro.petCategory,
                        onChanged: (String? p0) =>
                            marketPro.setPetCategory(p0))),
                Expanded(
                  child: LocationField(
                    initialText: marketPro.selectedLocationName,
                    onLocationSelected: (LocationNameEntity location) async {
                      final LatLng coords = await marketPro
                          .getLocationCoordinates(location.description);
                      marketPro.updateLocation(coords, location.description);
                    },
                  ),
                )
              ],
            ));
  }
}
