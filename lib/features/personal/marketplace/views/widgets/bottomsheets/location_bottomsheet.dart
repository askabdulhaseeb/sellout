// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../core/widgets/custom_elevated_button.dart';
// import '../../../../auth/signin/data/sources/local/local_auth.dart';
// import '../../providers/marketplace_provider.dart';

// class LocationRadiusBottomSheet extends StatelessWidget {
//   const LocationRadiusBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final MarketPlaceProvider provider =
//         Provider.of<MarketPlaceProvider>(context);

//     return Container(
//       padding: const EdgeInsets.all(16),
//       height: 550,
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('cancel'.tr())),
//               Text(
//                 'location'.tr(),
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//               ),
//               TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('apply'.tr())),
//             ],
//           ),
//           TextField(
//             controller: TextEditingController(),
//             decoration: InputDecoration(
//               hintText: 'search'.tr(),
//               prefixIcon: const Icon(Icons.search),
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           ),
//           const SizedBox(height: 4),

//           // 🔹 Google Map Widget
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(, longitude)
//                 zoom: 12.0, // Default zoom level
//               ),
//               markers: <Marker>{
//                 Marker(
//                   markerId: const MarkerId('selected-location'),
//                   position: provider.selectedLocation,
//                   infoWindow: const InfoWindow(title: 'Selected Location'),
//                 ),
//               },
//               circles: <Circle>{
//                 Circle(
//                   circleId: const CircleId('radius'),
//                   center: provider.selectedLocation,
//                   radius: (provider.radiusType == 'local'
//                           ? provider.selectedRadius
//                           : 10000) *
//                       1000, // 10,000 km for worldwide
//                   fillColor: Colors.blue.withOpacity(0.3),
//                   strokeWidth: 2,
//                   strokeColor: Colors.blue,
//                 ),
//               },
//               onMapCreated: provider.onMapCreated,
//               onTap: provider.onLocationChanged,
//             ),
//           ),

//           const SizedBox(height: 4),

//           // 🔹 Radio Buttons for Radius Type
//           Column(
//             children: <Widget>[
//               _buildRadiusOption(
//                 context: context,
//                 title: 'worldwide_radius'.tr(),
//                 subtitle: 'Show_listings_anywhere'.tr(),
//                 value: 'worldwide',
//               ),
//               _buildRadiusOption(
//                 context: context,
//                 title: 'local_radius'.tr(),
//                 subtitle: 'Show_specific_listings'.tr(),
//                 value: 'local',
//               ),
//             ],
//           ),

//           // 🔹 Slider for Radius (Only When Local is Selected)
//           if (provider.radiusType == 'local')
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Slider(
//                     value: provider.selectedRadius,
//                     min: 1.0,
//                     max: 100.0,
//                     divisions: 99,
//                     label: '${provider.selectedRadius.toStringAsFixed(1)} km',
//                     onChanged: (double value) {
//                       provider.selectRadius = value;
//                     },
//                   ),
//                 ),
//                 Text(
//                   '${provider.selectedRadius.toStringAsFixed(1)} km',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),

//           CustomElevatedButton(
//             isLoading: false,
//             onTap: () {},
//             title: 'Update Location',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRadiusOption(
//       {required BuildContext context,
//       required String title,
//       required String subtitle,
//       required String value}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(title, style: const TextStyle(fontSize: 12)),
//             Text(subtitle, style: const TextStyle(fontSize: 10)),
//           ],
//         ),
//         Radio<String>(
//           value: value,
//           groupValue: context.read<MarketPlaceProvider>().radiusType,
//           onChanged: (String? newValue) {
//             context.read<MarketPlaceProvider>().radiusType = newValue!;
//           },
//         ),
//       ],
//     );
//   }
// }
