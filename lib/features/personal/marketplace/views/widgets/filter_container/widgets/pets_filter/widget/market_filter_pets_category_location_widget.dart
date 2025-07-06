import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../domain/entities/location_name_entity.dart';
import '../../../../../providers/marketplace_provider.dart';
import '../../../../bottomsheets/location_radius_bottomsheet/widget/marketplace_location_field.dart';

class MarketFilterpetsCategoryAndLocationWIdget extends StatelessWidget {
  const MarketFilterpetsCategoryAndLocationWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Row(
      spacing: 4,
      children: <Widget>[
        Expanded(
            child: CustomListingDropDown(
                hint: 'category',
                categoryKey: 'pets',
                selectedValue: marketPro.petCategory,
                onChanged: (String? p0) => marketPro.setPetCategory(p0))),
        Expanded(
          child: MarketplaceLocationField(
            initialText: marketPro.selectedLocationName,
            onLocationSelected: (LocationNameEntity location) async {
              final LatLng coords =
                  await marketPro.getLocationCoordinates(location.description);
              marketPro.updateLocation(coords, location.description);
            },
          ),
        )
      ],
    );
  }
}
