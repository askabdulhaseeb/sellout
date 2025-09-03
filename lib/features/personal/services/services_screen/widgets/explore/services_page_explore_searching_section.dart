import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/leaflet_map_field.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../providers/services_page_provider.dart';

class ServicesPageExploreSearchingSection extends StatelessWidget {
  const ServicesPageExploreSearchingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              controller: pro.search,
              prefixIcon: const Icon(Icons.search),
              hint: 'search'.tr(),
              onChanged: (String value) {
                pro.querySearching();
              },
            ),
            LocationDropdown(
              selectedLatLng: pro.selectedLatLng,
              displayMode: MapDisplayMode.neverShowMap,
              initialText: pro.selectedLocationName,
              onLocationSelected: (LocationEntity p0, LatLng p1) {
                pro.updateLocation(p1, p0.address ?? '');
              },
            )
          ],
        );
      },
    );
  }
}
