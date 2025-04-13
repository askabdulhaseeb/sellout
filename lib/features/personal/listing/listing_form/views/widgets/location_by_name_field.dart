import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../services/get_it.dart';
import '../../../../explore/domain/entities/location_name_entity.dart';
import '../../../../explore/domain/usecase/location_name_usecase.dart';
import '../providers/add_listing_form_provider.dart';

class LocationInputField extends StatefulWidget {
  const LocationInputField({super.key});

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  List<LocationNameEntity> _suggestions = <LocationNameEntity>[];
  bool _isLoading = false;
  late AddListingFormProvider pro;
  final FocusNode _focusNode = FocusNode();
  LatLng? _selectedLatLng;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _suggestions = <LocationNameEntity>[];
        });
      }
    });
  }

  void _onChanged(String value) async {
    if (value.length < 2) {
      setState(() {
        _suggestions = <LocationNameEntity>[];
      });
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

  Future<void> _onSuggestionTap(LocationNameEntity suggestion) async {
    pro.location.text = suggestion.structuredFormatting.mainText;
    pro.setSelectedLocation(suggestion);

    setState(() {
      _suggestions = <LocationNameEntity>[];
    });

    /// 🔄 Simulate LatLng from place_id (you need to implement this properly)
    // Replace with real lat/lng fetched from Google Places Details API
    final LatLng simulatedLatLng = LatLng(31.5204, 74.3587); // Lahore

    setState(() {
      _selectedLatLng = simulatedLatLng;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(simulatedLatLng),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    pro = Provider.of<AddListingFormProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextFormField(
          controller: pro.location,
          labelText: 'Location',
          hint: 'search...'.tr(),
          keyboardType: TextInputType.text,
          onChanged: _onChanged,
        ),
        if (_isLoading) const LinearProgressIndicator(),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: _suggestions.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final LocationNameEntity suggestion = _suggestions[index];
                return ListTile(
                  title: Text(suggestion.structuredFormatting.mainText),
                  onTap: () => _onSuggestionTap(suggestion),
                );
              },
            ),
          ),

        /// 🗺 Show Map when location is selected
        if (_selectedLatLng != null)
          Container(
            height: 200,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _selectedLatLng!,
                  zoom: 14,
                ),
                markers: <Marker>{
                  Marker(
                    markerId:  MarkerId('selected-location'.tr()),
                    position: _selectedLatLng!,
                  ),
                },
              ),
            ),
          ),
      ],
    );
  }
}
