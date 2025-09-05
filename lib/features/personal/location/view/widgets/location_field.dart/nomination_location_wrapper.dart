import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../services/get_it.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/enums/map_display_mode.dart';
import '../../provider/location_field_provider.dart';
import 'nomination_location_field.dart';

class NominationLocationFieldWrapper extends StatelessWidget {
  const NominationLocationFieldWrapper({
    required this.onLocationSelected,
    required this.selectedLatLng,
    super.key,
    this.initialText,
    this.icon,
    this.displayMode = MapDisplayMode.showMapAfterSelection,
    this.showMapCircle = false,
    this.circleRadius,
    this.radiusType = RadiusType.worldwide,
  });

  final void Function(LocationEntity, LatLng) onLocationSelected;
  final String? initialText;
  final Widget? icon;
  final MapDisplayMode displayMode;
  final bool? showMapCircle;
  final double? circleRadius;
  final LatLng? selectedLatLng;
  final RadiusType radiusType;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(locator()),
      builder: (BuildContext context, Widget? child) => NominationLocationField(
        onLocationSelected: onLocationSelected,
        selectedLatLng: selectedLatLng,
        initialText: initialText,
        icon: icon,
        displayMode: displayMode,
        showMapCircle: showMapCircle,
        circleRadius: circleRadius,
        radiusType: radiusType,
      ),
    );
  }
}
