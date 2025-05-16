import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../features/business/core/data/sources/local_business.dart';
import '../../../../../features/business/core/data/sources/service/local_service.dart';
import '../../../../../features/business/core/domain/entity/service/service_entity.dart';
import '../../../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../../../features/business/core/domain/entity/business_entity.dart';
import '../../../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../../extension/datetime_ext.dart';
import '../../../in_dev_mode.dart';
import '../../../profile_photo.dart';
import '../widgets/appointment_tile_button_section.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({
    required this.booking,
    super.key,
  });
  final BookingEntity booking;
  Future<UserEntity?> _getUser() async {
    final String userId =
        booking.amICustomer ? booking.employeeID : booking.customerID;
    return await LocalUser().user(userId);
  }

  Future<BusinessEntity?> _getBusiness() async {
    return await LocalBusiness().getBusiness(booking.businessID ?? '');
  }

  Future<ServiceEntity?> _getService() async {
    return await LocalService().getService(booking.serviceID ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${booking.bookedAt.toLocal()}'.split(' ')[0]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait(
            <Future<dynamic>>[_getUser(), _getBusiness(), _getService()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final UserEntity? user = snapshot.data![0] as UserEntity?;
          final BusinessEntity? business = snapshot.data![1] as BusinessEntity?;
          final ServiceEntity? service = snapshot.data![2] as ServiceEntity?;
          if (user == null || business == null) {
            return const Center(
                child: Text('User or Business data not found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Appointment map
                AppointmentMapSection(business: business),
                const SizedBox(height: 12),
                AppointmentDescriptionSection(
                  business: business,
                  service: service,
                  user: user,
                  booking: booking,
                ),

                const InDevMode(
                    child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(child: Text('TODO: Payment detail section')),
                ))
              ],
            ),
          );
        },
      ),
      bottomSheet: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 140,
        child: AppointmentTileButtonSection(
          booking: booking,
        ),
      ),
    );
  }
}

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
              initialCameraPosition: const CameraPosition(
                target: LatLng(40.7128, -74.0060),
                zoom: 14,
              ),
              markers: <Marker>{
                Marker(
                  markerId: const MarkerId('businessLocation'),
                  position: const LatLng(40.7128, -74.0060),
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
                          business.location?.address ?? 'N/A',
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

class AppointmentDescriptionSection extends StatelessWidget {
  const AppointmentDescriptionSection({
    required this.business,
    required this.service,
    required this.user,
    required this.booking,
    super.key,
  });

  final BusinessEntity business;
  final ServiceEntity? service;
  final UserEntity user;
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          business.displayName ?? '',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              service?.name ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              service?.price.toString() ?? '',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                '${'with'.tr()} ${user.displayName}:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorScheme.of(context).outline),
              ),
            ),
            Text(
              '${booking.bookedAt.timeOnly} - ${booking.endAt.timeOnly}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorScheme.of(context).outline),
            ),
            const Divider(),
          ],
        ),
      ],
    );
  }
}
