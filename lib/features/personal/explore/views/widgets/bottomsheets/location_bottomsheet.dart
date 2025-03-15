import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/explore_provider.dart';

class LocationRadiusBottomSheet extends StatefulWidget {
  const LocationRadiusBottomSheet({super.key});

  @override
  State<LocationRadiusBottomSheet> createState() =>
      _LocationRadiusBottomSheetState();
}

class _LocationRadiusBottomSheetState extends State<LocationRadiusBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  String radiusType = 'local';
  LatLng selectedLocation =
      const LatLng(37.7749, -122.4194); // Default Location

  GoogleMapController? mapController;
  double selectedRadius = 10.0; // Default radius in km

  @override
  Widget build(BuildContext context) {
    final ExploreProvider provider = Provider.of<ExploreProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      height: 550,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr())),
              Text(
                'location'.tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('apply'.tr())),
            ],
          ),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'search'.tr(),
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 4),

          // 🔹 Google Map Widget
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLocation,
                zoom: 12.0, // Default zoom level
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: selectedLocation,
                  infoWindow: const InfoWindow(title: "Selected Location"),
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId('radius'),
                  center: selectedLocation,
                  radius: (radiusType == 'local' ? selectedRadius : 10000) *
                      1000, // 10,000 km for worldwide
                  fillColor: Colors.blue.withOpacity(0.3),
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              onTap: (LatLng location) {
                setState(() {
                  selectedLocation = location;
                });
              },
            ),
          ),

          const SizedBox(height: 4),

          // 🔹 Radio Buttons for Radius Type
          Column(
            children: <Widget>[
              _buildRadiusOption(
                title: 'worldwide_radius'.tr(),
                subtitle: 'Show_listings_anywhere'.tr(),
                value: 'worldwide',
              ),
              _buildRadiusOption(
                title: 'local_radius'.tr(),
                subtitle: 'Show_specific_listings'.tr(),
                value: 'local',
              ),
            ],
          ),

          // 🔹 Slider for Radius (Only When Local is Selected)
          if (radiusType == 'local')
            Row(
              children: <Widget>[
                Expanded(
                  child: Slider(
                    value: selectedRadius,
                    min: 1.0,
                    max: 100.0,
                    divisions: 99,
                    label: '${selectedRadius.toStringAsFixed(1)} km',
                    onChanged: (double value) {
                      if (radiusType == 'local') {
                        setState(() {
                          selectedRadius = value;
                        });
                      }
                    },
                  ),
                ),
                Text(
                  '${selectedRadius.toStringAsFixed(1)} km',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

          CustomElevatedButton(
            isLoading: false,
            onTap: () {},
            title: 'Update Location',
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Method for Radius Selection
  Widget _buildRadiusOption(
      {required String title,
      required String subtitle,
      required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(subtitle, style: const TextStyle(fontSize: 10)),
          ],
        ),
        Radio<String>(
          value: value,
          groupValue: radiusType,
          onChanged: (String? newValue) {
            setState(() {
              radiusType = newValue!;
              if (radiusType == 'worldwide') {
                selectedRadius = 10000; // Fixed worldwide radius
              } else {
                selectedRadius = 10.0; // Reset to default for local
              }
            });
          },
        ),
      ],
    );
  }
}
