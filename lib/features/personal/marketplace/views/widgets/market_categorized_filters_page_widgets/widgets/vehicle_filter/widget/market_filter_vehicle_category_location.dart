import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterVehicleCategoryAndLocationWIdget extends StatelessWidget {
  const MarketFilterVehicleCategoryAndLocationWIdget({
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
            child: CustomTextFormField(
              controller: marketPro.vehicleModel,
              hint: 'model'.tr(),
            ),
          ),
          Expanded(
            child: NominationLocationFieldWrapper(
              selectedLatLng: marketPro.selectedlatlng,
              displayMode: MapDisplayMode.neverShowMap,
              initialText: marketPro.selectedLocation?.title ?? '',
              onLocationSelected: (LocationEntity p0, LatLng p1) {
                marketPro.updateLocation(p1, p0);
              },
            ),
          )
        ],
      ),
    );
  }
}
