import 'package:flutter/material.dart';
import '../../../../location/domain/entities/location_entity.dart';

class PostDetailPropertyLocationLocationWidget extends StatelessWidget {
  const PostDetailPropertyLocationLocationWidget({
    super.key,
    required this.location,
  });
  final LocationEntity? location;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // final LatLng position =
    //     LatLng(location?.latitude ?? 0, location?.longitude ?? 0);

    // return GestureDetector(
    //   onTap: () async {
    //     final Uri url = Uri.parse(
    //       location?.url ?? 'www.text.com',
    //     );
    //     if (await canLaunchUrl(url)) {
    //       await launchUrl(url, mode: LaunchMode.externalApplication);
    //     }
    //   },
    //   child: Container(
    //     margin: const EdgeInsets.all(16),
    //     height: 200,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(16),
    //       child: GoogleMap(
    //         initialCameraPosition: CameraPosition(
    //           target: position,
    //           zoom: 15,
    //         ),
    //         markers: <Marker>{
    //           Marker(
    //             markerId: const MarkerId("location"),
    //             position: position,
    //           )
    //         },
    //         zoomControlsEnabled: false,
    //         myLocationButtonEnabled: false,
    //         onMapCreated: (GoogleMapController controller) {},
    //         gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
    //             .toSet(), // to disable gestures
    //       ),
    //     ),
    //   ),
    // );
  }
}
