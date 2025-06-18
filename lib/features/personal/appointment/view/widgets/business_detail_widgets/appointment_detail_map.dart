import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../core/widgets/profile_photo.dart';

class AppointmentMapSection extends StatelessWidget {
  const AppointmentMapSection({
    required this.business,
    super.key,
  });

  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(business.location?.latitude ?? 40.7128,
                    business.location?.longitude ?? -74.0060),
                zoom: 14,
              ),
              markers: <Marker>{
                Marker(
                  markerId: MarkerId(business.displayName ?? ''),
                  position: LatLng(business.location?.latitude ?? 40.7128,
                      business.location?.longitude ?? -74.0060),
                  infoWindow: InfoWindow(title: business.displayName),
                ),
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  ProfilePhoto(
                    size: 24,
                    isCircle: true,
                    url: business.logo?.url,
                    placeholder: business.displayName.toString(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          business.displayName ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          business.location?.address ?? 'na'.tr(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
