import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../services/get_it.dart';
import '../../../../explore/domain/entities/location_name_entity.dart';
import '../../../../explore/domain/usecase/location_name_usecase.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../../location/domain/entities/location_entity.dart';

class LocationInputField extends StatefulWidget {
  const LocationInputField({
    required this.onLocationSelected,
    super.key,
    this.controller,
    this.initialLocation,
  });
  final ValueChanged<LocationModel> onLocationSelected;
  final TextEditingController? controller;
  final LocationEntity? initialLocation;

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  List<LocationNameEntity> _suggestions = <LocationNameEntity>[];
  bool _isLoading = false;
  LatLng? _selectedLatLng;
  GoogleMapController? _mapController;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _initializeFromExistingLocation();
    _focusNode.addListener(_onFocusChange);
  }

  void _initializeFromExistingLocation() {
    if (widget.initialLocation != null) {
      _controller.text = widget.initialLocation!.title ?? '';
      if (widget.initialLocation!.latitude != null &&
          widget.initialLocation!.longitude != null) {
        _selectedLatLng = LatLng(
          widget.initialLocation!.latitude!,
          widget.initialLocation!.longitude!,
        );
      }
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() => _suggestions = <LocationNameEntity>[]);
    }
  }

  void _onChanged(String value) async {
    if (value.length < 2) {
      setState(() => _suggestions = <LocationNameEntity>[]);
      return;
    }

    setState(() => _isLoading = true);

    final DataState<List<LocationNameEntity>> result =
        await LocationByNameUsecase(locator()).call(value);

    setState(() {
      _isLoading = false;
      _suggestions = result.entity ?? <LocationNameEntity>[];
    });
  }

  Future<LatLng> _coordsFromAddress(String address) async {
    final List<Location> locations = await locationFromAddress(address);
    if (locations.isEmpty) throw Exception('No results for: $address');
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  Future<void> _onSuggestionTap(LocationNameEntity suggestion) async {
    _controller.text = suggestion.structuredFormatting.mainText;
    setState(() => _suggestions = <LocationNameEntity>[]);
    _focusNode.unfocus();

    try {
      final bool hasConnection = await InternetAddress.lookup('google.com')
          .then((_) => true)
          .catchError((_) => false);
      if (!hasConnection) throw 'NO_INTERNET';

      final LatLng latLng = await _coordsFromAddress(suggestion.description)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw 'TIMEOUT');

      setState(() => _selectedLatLng = latLng);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));

      // Create and return LocationModel
      final LocationModel locationModel = LocationModel(
        address: suggestion.description,
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        title: suggestion.structuredFormatting.mainText,
        id: suggestion.placeId,
        url: 'www.test.com',
      );

      widget.onLocationSelected(locationModel);
    } on PlatformException catch (e) {
      _handleError(e.code, 'Platform error: ${e.message}');
    } on SocketException {
      _handleError('NO_INTERNET', 'Network error');
    } catch (e) {
      _handleError('GENERIC_ERROR', e.toString());
    }
  }

  void _handleError(String code, String message) {
    AppLog.error(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_errorMessages[code] ?? 'Unknown error'.tr())),
    );
  }

  final Map<String, String> _errorMessages = <String, String>{
    'IO_ERROR': 'maps_service_unavailable'.tr(),
    'NO_INTERNET': 'no_internet'.tr(),
    'TIMEOUT': 'request_timeout'.tr(),
    'GENERIC_ERROR': 'location_error'.tr()
  };

  @override
  void dispose() {
    _focusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Focus(
          focusNode: _focusNode,
          child: CustomTextFormField(
            controller: _controller,
            labelText: 'location'.tr(),
            hint: 'search_location'.tr(),
            onChanged: _onChanged,
          ),
        ),
        if (_isLoading) const LinearProgressIndicator(),
        if (_suggestions.isNotEmpty)
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 240),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                physics: const ClampingScrollPhysics(),
                itemCount: _suggestions.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (BuildContext context, int index) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => _onSuggestionTap(_suggestions[index]),
                    borderRadius: BorderRadius.circular(8),
                    splashFactory: InkRipple.splashFactory,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _suggestions[index]
                                      .structuredFormatting
                                      .mainText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_suggestions[index]
                                    .structuredFormatting
                                    .secondaryText
                                    .isNotEmpty)
                                  if (_suggestions[index]
                                      .structuredFormatting
                                      .secondaryText
                                      .isNotEmpty)
                                    Text(
                                      _suggestions[index]
                                          .structuredFormatting
                                          .secondaryText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                const Divider()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (_selectedLatLng != null)
          Container(
            height: 200,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                onMapCreated: (GoogleMapController ctrl) =>
                    _mapController = ctrl,
                initialCameraPosition: CameraPosition(
                  target: _selectedLatLng!,
                  zoom: 14,
                ),
                markers: <Marker>{
                  Marker(
                    markerId: const MarkerId('selected-location'),
                    position: _selectedLatLng!,
                    infoWindow: InfoWindow(title: _controller.text),
                  )
                },
              ),
            ),
          ),
      ],
    );
  }
}
