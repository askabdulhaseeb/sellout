// location_input_field.dart
import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
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
  LatLng? _selectedLatLng;
  GoogleMapController? _mapController;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _initializeFromExistingLocation();
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

  Future<void> _handleLocationSelection(LocationNameEntity suggestion) async {
    _controller.text = suggestion.structuredFormatting.mainText;
    try {
      final LatLng latLng =
          await _getLocationCoordinates(suggestion.description);
      _updateMapLocation(latLng);
      _emitLocationModel(suggestion, latLng);
    } catch (e) {
      _handleLocationError(e);
    }
  }

  Future<LatLng> _getLocationCoordinates(String address) async {
    final bool hasConnection = await _checkInternetConnection();
    if (!hasConnection) throw 'NO_INTERNET';

    final List<Location> locations = await locationFromAddress(address)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw 'TIMEOUT';
    });

    if (locations.isEmpty) throw 'NO_RESULTS';
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } on SocketException {
      return false;
    }
  }

  void _updateMapLocation(LatLng latLng) {
    setState(() => _selectedLatLng = latLng);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
  }

  void _emitLocationModel(LocationNameEntity suggestion, LatLng latLng) {
    final LocationModel locationModel = LocationModel(
      address: suggestion.description,
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      title: suggestion.structuredFormatting.mainText,
      id: suggestion.placeId,
      url: 'www.test.com',
    );
    widget.onLocationSelected(locationModel);
  }

  void _handleLocationError(dynamic error) {
    AppLog.error(error.toString());
    String message = 'something_wrong'.tr();
    if (error == 'NO_INTERNET') message = 'no_internet'.tr();
    if (error == 'TIMEOUT') message = 'timeout'.tr();
    if (error == 'NO_RESULTS') message = 'no_results'.tr();
    AppSnackBar.showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LocationSearchField(
          controller: _controller,
          onLocationSelected: _handleLocationSelection,
          initialText: widget.initialLocation?.title,
        ),
        if (_selectedLatLng != null)
          LocationMapPreview(
            latLng: _selectedLatLng!,
            locationName: _controller.text,
            onMapCreated: (GoogleMapController controller) =>
                _mapController = controller,
          ),
      ],
    );
  }
}

class LocationSearchField extends StatefulWidget {
  const LocationSearchField({
    required this.controller,
    required this.onLocationSelected,
    super.key,
    this.initialText,
  });

  final TextEditingController controller;
  final ValueChanged<LocationNameEntity> onLocationSelected;
  final String? initialText;

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  List<LocationNameEntity> _suggestions = <LocationNameEntity>[];
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      widget.controller.text = widget.initialText!;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && _suggestions.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) => SuggestionsOverlay(
        layerLink: _layerLink,
        suggestions: _suggestions,
        isLoading: _isLoading,
        onSuggestionSelected: (LocationNameEntity suggestion) {
          widget.onLocationSelected(suggestion);
          _focusNode.unfocus();
          _removeOverlay();
        },
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.length < 2) {
      setState(() => _suggestions = <LocationNameEntity>[]);
      return;
    }

    setState(() => _isLoading = true);
    final DataState<List<LocationNameEntity>> result =
        await LocationByNameUsecase(locator()).call(query);
    setState(() {
      _isLoading = false;
      _suggestions = result.entity ?? <LocationNameEntity>[];
    });

    if (_suggestions.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'meetup_location'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: const OutlineInputBorder(),
              hintText: 'search_location'.tr(),
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
            onChanged: (String value) =>
                _debouncer.run(() => _fetchSuggestions(value)),
          ),
        ],
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class SuggestionsOverlay extends StatelessWidget {
  const SuggestionsOverlay({
    required this.layerLink,
    required this.suggestions,
    required this.isLoading,
    required this.onSuggestionSelected,
    super.key,
  });

  final LayerLink layerLink;
  final List<LocationNameEntity> suggestions;
  final bool isLoading;
  final ValueChanged<LocationNameEntity> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: _getFieldWidth(context),
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 48),
        child: Material(
          elevation: 4,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (suggestions.isEmpty) {
      return Center(child: Text('no_results'.tr()));
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) => SuggestionTile(
        suggestion: suggestions[index],
        onTap: () => onSuggestionSelected(suggestions[index]),
      ),
    );
  }

  double _getFieldWidth(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? MediaQuery.of(context).size.width;
  }
}

class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    required this.suggestion,
    required this.onTap,
    super.key,
  });

  final LocationNameEntity suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text(suggestion.structuredFormatting.mainText),
      subtitle: suggestion.structuredFormatting.secondaryText.isNotEmpty
          ? Text(suggestion.structuredFormatting.secondaryText)
          : null,
      onTap: onTap,
    );
  }
}

class LocationMapPreview extends StatelessWidget {
  const LocationMapPreview({
    required this.latLng,
    required this.locationName,
    required this.onMapCreated,
    super.key,
  });

  final LatLng latLng;
  final String locationName;
  final ValueChanged<GoogleMapController> onMapCreated;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: latLng,
            zoom: 14,
          ),
          markers: <Marker>{
            Marker(
              markerId: const MarkerId('selectedLocation'),
              position: latLng,
              infoWindow: InfoWindow(title: locationName),
            ),
          },
        ),
      ),
    );
  }
}
