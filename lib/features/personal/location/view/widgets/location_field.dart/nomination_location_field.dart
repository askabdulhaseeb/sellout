import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';
import '../../../domain/enums/map_display_mode.dart';
import '../../../domain/usecase/location_name_usecase.dart';
import '../maps/flutter_location_map.dart';

class NominationLocationField extends StatefulWidget {
  const NominationLocationField({
    required this.onLocationSelected,
    required this.selectedLatLng,
    required this.validator,
    this.title = '',
    this.hint = '',
    super.key,
    this.initialText,
    this.prefixIcon,
    this.showSuffixIcon = false,
    this.icon,
    this.displayMode = MapDisplayMode.showMapAfterSelection,
    this.showMapCircle = false,
    this.circleRadius,
    this.radiusType = RadiusType.worldwide,
  });

  final void Function(LocationEntity, LatLng) onLocationSelected;
  final String? initialText;
  final IconData? prefixIcon;
  final bool? showSuffixIcon;
  final Widget? icon;
  final MapDisplayMode displayMode;
  final String title;
  final String hint;
  final bool? showMapCircle;
  final double? circleRadius;
  final LatLng? selectedLatLng;
  final RadiusType radiusType;
  final String? Function(bool?) validator;

  @override
  State<NominationLocationField> createState() =>
      _NominationLocationFieldState();
}

class _NominationLocationFieldState extends State<NominationLocationField> {
  @override
  void didUpdateWidget(covariant NominationLocationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If selectedLatLng changed or became null, reset controller and map
    if (widget.selectedLatLng != oldWidget.selectedLatLng) {
      if (widget.selectedLatLng == null &&
          (widget.initialText == null || widget.initialText!.isEmpty)) {
        _controller.clear();
        setState(() {});
      }
    }
  }
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
  void setLoading(bool val) {
  }

  Future<List<NominationLocationEntity>> fetchSuggestions(String query) async {
    if (query.trim().isEmpty) return <NominationLocationEntity>[];
    setLoading(true);

    // Call your usecase directly
    final DataState<List<NominationLocationEntity>> result =
        await NominationLocationUsecase(locator()).call(query);

    List<NominationLocationEntity> suggestions = <NominationLocationEntity>[];
    if (result is DataSuccess<List<NominationLocationEntity>>) {
      suggestions = result.entity ?? <NominationLocationEntity>[];
    }

    setLoading(false);
    return suggestions;
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

    setState(() {
      _selectedLatLng = latLng;
      _controller.text = suggestion.displayName;
    });

    Future<void>.microtask(() {
      try {
        _mapController.move(latLng, 15);
      } catch (_) {}
    });

    widget.onLocationSelected(location, latLng);
  }

  bool _shouldShowMap() {
    return widget.displayMode == MapDisplayMode.alwaysShowMap ||
        (widget.displayMode == MapDisplayMode.showMapAfterSelection &&
            _controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomDropdown<NominationLocationEntity>(
          prefixIcon: widget.prefixIcon,
          sufixIcon: widget.showSuffixIcon,
          selectedItem: null,
          validator: widget.validator,
          title: widget.title != '' ? widget.title : '',
          items: const <DropdownMenuItem<NominationLocationEntity>>[],
          initialText: widget.initialText,
          hint: widget.hint != '' ? widget.hint : 'location'.tr(),
          searchBy: (DropdownMenuItem<NominationLocationEntity> item) =>
              item.value?.displayName ?? '',
          onSearchChanged: (String query) async {
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            final Completer<List<DropdownMenuItem<NominationLocationEntity>>>
                completer =
                Completer<List<DropdownMenuItem<NominationLocationEntity>>>();

            _debounce = Timer(const Duration(milliseconds: 500), () async {
              if (query.isEmpty) {
                completer
                    .complete(<DropdownMenuItem<NominationLocationEntity>>[]);
                return;
              }
              final List<NominationLocationEntity> results =
                  await fetchSuggestions(query);
              final List<DropdownMenuItem<NominationLocationEntity>> items =
                  results.map((NominationLocationEntity loc) {
                return DropdownMenuItem<NominationLocationEntity>(
                  value: loc,
                  child: Text(loc.displayName,
                      maxLines: 2, style: TextTheme.of(context).labelSmall),
                );
              }).toList();
              completer.complete(items);
            });
            return completer.future;
          },
          onChanged: (NominationLocationEntity? suggestion) {
            if (suggestion != null) _handleSuggestionSelected(suggestion);
          },
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
}
