import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';
import '../../../domain/enums/map_display_mode.dart';
import '../../provider/location_field_provider.dart';
import '../maps/flutter_location_map.dart';

class NominationLocationField extends StatefulWidget {
  const NominationLocationField({
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
  State<NominationLocationField> createState() =>
      _NominationLocationFieldWrapperState();
}

class _NominationLocationFieldWrapperState
    extends State<NominationLocationField> {
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();
  late LatLng _selectedLatLng;
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _selectedLatLng = widget.selectedLatLng ?? LocalAuth.latlng;
    if (widget.initialText?.isNotEmpty == true) {
      _controller.text = widget.initialText!;
    }
  }

  Future<List<NominationLocationEntity>> _debouncedSearch(
      String query, LocationProvider provider) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final Completer<List<NominationLocationEntity>> completer =
        Completer<List<NominationLocationEntity>>();
    _debounce = Timer(const Duration(seconds: 1), () async {
      final List<NominationLocationEntity> results =
          await provider.fetchSuggestions(query);
      completer.complete(results);
    });
    return completer.future;
  }

  void _handleSuggestionSelected(NominationLocationEntity suggestion) {
    final double lat = suggestion.lat;
    final double lon = suggestion.lon;
    final LatLng latLng = LatLng(lat, lon);

    final LocationEntity location = LocationEntity(
      id: suggestion.placeId,
      title: suggestion.address?.city ??
          suggestion.address?.state ??
          suggestion.displayName.split(',').first,
      address: suggestion.displayName,
      url: 'https://maps.google.com/?q=$lat,$lon',
      latitude: lat,
      longitude: lon,
    );

    setState(() => _selectedLatLng = latLng);
    // move map safely
    Future<void>.microtask(() {
      try {
        _mapController.move(latLng, 15);
      } catch (_) {}
    });

    widget.onLocationSelected(location, latLng);
  }

  @override
  Widget build(BuildContext context) {
    final LocationProvider provider = context.read<LocationProvider>();

    return Column(
      children: <Widget>[
        TypeAheadField<NominationLocationEntity>(
          controller: _controller,
          suggestionsCallback: (String query) =>
              _debouncedSearch(query, provider),
          itemBuilder:
              (BuildContext context, NominationLocationEntity suggestion) =>
                  ListTile(
            title: Text(
              suggestion.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onSelected: _handleSuggestionSelected,
          builder: (BuildContext context, TextEditingController controller,
                  FocusNode focusNode) =>
              CustomTextFormField(
            hint: 'select_location'.tr(),
            controller: controller,
            focusNode: focusNode,
            prefixIcon: widget.icon ?? const Icon(Icons.search),
          ),
          emptyBuilder: (_) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('no_location_found'.tr(), textAlign: TextAlign.center),
          ),
        ),
        if (_shouldShowMap()) const SizedBox(height: 16),
        if (_shouldShowMap())
          FlutterLocationMap(
            mapController: _mapController,
            selectedLatLng: _selectedLatLng,
            circleRadius: widget.circleRadius,
            radiusType: widget.radiusType,
            showMapCircle: widget.showMapCircle ?? false,
          ),
      ],
    );
  }

  bool _shouldShowMap() {
    return widget.displayMode == MapDisplayMode.alwaysShowMap ||
        (widget.displayMode == MapDisplayMode.showMapAfterSelection &&
            _controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
