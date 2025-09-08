import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../domain/enum/radius_type.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import 'widget/location_header.dart';
import 'widget/radius_option.dart';
import 'widget/radius_slider.dart';

class LocationRadiusBottomSheet extends StatefulWidget {
  const LocationRadiusBottomSheet({
    required this.initialRadiusType,
    required this.initialRadius,
    required this.initialLatLng,
    required this.onApply,
    required this.onUpdateLocation,
    required this.onReset,
    this.initialLocation,
    super.key,
  });

  final RadiusType initialRadiusType;
  final double initialRadius;
  final LatLng initialLatLng;
  final LocationEntity? initialLocation;

  final void Function() onApply;
  final void Function() onReset;
  final void Function(
    RadiusType radiusType,
    double radius,
    LatLng latlng,
    LocationEntity? location,
  ) onUpdateLocation;

  @override
  State<LocationRadiusBottomSheet> createState() =>
      _LocationRadiusBottomSheetState();
}

class _LocationRadiusBottomSheetState extends State<LocationRadiusBottomSheet> {
  late RadiusType _radiusType;
  late double _selectedRadius;
  late LatLng _selectedLatLng;
  LocationEntity? _selectedLocation;
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    // Delay heavy build until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _radiusType = widget.initialRadiusType;
      _selectedRadius = widget.initialRadius;
      _selectedLatLng = widget.initialLatLng;
      _selectedLocation = widget.initialLocation;
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  void _updateLocation(LatLng latlng, LocationEntity location) {
    setState(() {
      _selectedLatLng = latlng;
      _selectedLocation = location;
    });
  }

  void _updateRadius(double value) {
    setState(() {
      _selectedRadius = value;
    });
  }

  void _updateRadiusType(RadiusType type) {
    setState(() {
      _radiusType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        title: LocationHeader(
          onApply: () {
            widget.onUpdateLocation(
              _radiusType,
              _selectedRadius,
              _selectedLatLng,
              _selectedLocation,
            );
            widget.onApply();
            Navigator.pop(context);
          },
          onReset: () {
            widget.onReset();
            Navigator.pop(context);
          },
        ),
      ),
      body: !_isLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 8),
                  NominationLocationField(
                    hint: 'search_location_here'.tr(),
                    radiusType: _radiusType,
                    selectedLatLng: _selectedLatLng,
                    circleRadius: _selectedRadius,
                    displayMode: MapDisplayMode.alwaysShowMap,
                    showMapCircle: true,
                    initialText: _selectedLocation?.address,
                    onLocationSelected: (LocationEntity loc, LatLng latlng) =>
                        _updateLocation(latlng, loc),
                  ),
                  const SizedBox(height: 24),
                  RadiusOptions(
                    radiusType: _radiusType,
                    onChanged: _updateRadiusType,
                  ),
                  if (_radiusType == RadiusType.local) ...<Widget>[
                    const SizedBox(height: 8),
                    RadiusSlider(
                      selectedRadius: _selectedRadius,
                      onChanged: _updateRadius,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomElevatedButton(
                      isLoading: false,
                      onTap: () {
                        widget.onUpdateLocation(
                          _radiusType,
                          _selectedRadius,
                          _selectedLatLng,
                          _selectedLocation,
                        );
                        widget.onApply();
                        Navigator.pop(context);
                      },
                      title: 'update_location'.tr(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
