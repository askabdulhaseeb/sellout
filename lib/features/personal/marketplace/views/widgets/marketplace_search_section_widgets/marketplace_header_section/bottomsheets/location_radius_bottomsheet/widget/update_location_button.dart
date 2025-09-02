import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../providers/marketplace_provider.dart';

class UpdateLocationButton extends StatelessWidget {
  const UpdateLocationButton(
      {required this.latlng, required this.selectedLocation, super.key});
  final LatLng? latlng;
  final LocationEntity? selectedLocation;
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, Widget? child) =>
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomElevatedButton(
          isLoading: pro.isLoading,
          onTap: () {
            pro.updateLocation(latlng, selectedLocation);
            Navigator.pop(context);
          },
          title: 'Update Location'.tr(),
        ),
      ),
    );
  }
}
