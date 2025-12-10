import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/sources/api_call.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/enums/map_display_mode.dart';
import '../../../domain/usecase/location_name_usecase.dart';
import '../maps/flutter_location_map.dart';

class NominationLocationField extends StatefulWidget {
  const NominationLocationField({
    required this.onLocationSelected,
    required this.selectedLatLng,
    required this.validator,
    this.selectedLocation,
    this.title = '',
    this.hint = '',
    super.key,
    this.prefixIcon,
    this.showSuffixIcon = false,
    this.icon,
    this.displayMode = MapDisplayMode.showMapAfterSelection,
    this.showMapCircle = false,
    this.circleRadius,
    this.radiusType = RadiusType.worldwide,
  });
  final LocationEntity? selectedLocation;

  final void Function(LocationEntity, LatLng) onLocationSelected;
  final IconData? prefixIcon;
  final bool? showSuffixIcon;
  final Widget? icon;
  final MapDisplayMode displayMode;
  final String? title;
  final String? hint;
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
  TextEditingController? _typeAheadController;
  @override
  void didUpdateWidget(covariant NominationLocationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller and map with selectedLocation if it changes
    final LocationEntity? selected = widget.selectedLocation;
    final LocationEntity? oldSelected = oldWidget.selectedLocation;
    if (selected != null &&
        (oldSelected == null || selected.address != oldSelected.address)) {
      if (_typeAheadController != null) {
        _typeAheadController!.text = selected.address ?? '';
        _typeAheadController!.selection = TextSelection.collapsed(
          offset: _typeAheadController!.text.length,
        );
      }
      _controller.text = selected.address ?? '';
      _selectedLatLng = LatLng(selected.latitude, selected.longitude);
      Future<void>.microtask(() {
        try {
          _mapController.move(_selectedLatLng, 15);
        } catch (_) {}
      });
    } else if (selected == null && oldSelected != null) {
      // Clear controller when selectedLocation is reset to null
      if (_typeAheadController != null) {
        _typeAheadController!.clear();
      }
      _controller.clear();
    }
  }

  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();
  late LatLng _selectedLatLng;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      _controller.text = widget.selectedLocation!.address ?? '';
      _selectedLatLng = LatLng(
        widget.selectedLocation!.latitude,
        widget.selectedLocation!.longitude,
      );
    } else {
      _selectedLatLng = widget.selectedLatLng ?? LocalAuth.latlng;
    }
  }

  void setLoading(bool val) {}

  Future<List<LocationEntity>> fetchSuggestions(String query) async {
    if (query.trim().isEmpty) return <LocationEntity>[];
    setLoading(true);
    final DataState<List<LocationEntity>> result =
        await NominationLocationUsecase(locator()).call(query);
    List<LocationEntity> suggestions = <LocationEntity>[];
    if (result is DataSuccess<List<LocationEntity>>) {
      suggestions = result.entity ?? <LocationEntity>[];
    }
    setLoading(false);
    return suggestions;
  }

  void _handleSuggestionSelected(LocationEntity suggestion) {
    final LatLng latLng = LatLng(suggestion.latitude, suggestion.longitude);
    setState(() {
      _selectedLatLng = latLng;
    });
    Future<void>.microtask(() {
      try {
        _mapController.move(latLng, 15);
      } catch (_) {}
    });
    widget.onLocationSelected(suggestion, latLng);
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
        TypeAheadField<LocationEntity>(
          suggestionsCallback: (String pattern) async {
            // Prevent suggestions when field is reset/empty
            if ((_typeAheadController?.text ?? '').isEmpty) {
              return <LocationEntity>[];
            }
            return await fetchSuggestions(pattern);
          },
          builder:
              (
                BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
              ) {
                _typeAheadController = controller;
                // Show selected value if present
                if (widget.selectedLocation != null &&
                    controller.text.isEmpty) {
                  controller.text = widget.selectedLocation!.address ?? '';
                }
                return CustomTextFormField(
                  hint: widget.hint ?? 'location'.tr(),
                  labelText: widget.title ?? '',
                  controller: controller,
                  focusNode: focusNode,
                  onTap: () {
                    controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.text.length,
                    );
                  },
                );
              },
          itemBuilder: (BuildContext context, LocationEntity suggestion) {
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                suggestion.address ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).labelSmall,
              ),
            );
          },
          onSelected: (LocationEntity suggestion) {
            if (_typeAheadController != null) {
              _typeAheadController!.text = suggestion.address ?? '';
              _typeAheadController!.selection = TextSelection.collapsed(
                offset: _typeAheadController!.text.length,
              );
            }
            _handleSuggestionSelected(suggestion);
          },
          emptyBuilder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('no_data_found'.tr()),
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
}
