import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../features/business/core/data/sources/local_business.dart';
import '../../../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../../../features/business/core/domain/entity/business_entity.dart';
import '../../../../../features/personal/user/profiles/data/sources/local/local_user.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${booking.bookedAt.toLocal()}'.split(' ')[0]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait(<Future>[_getUser(), _getBusiness()]),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final UserEntity? user = snapshot.data![0] as UserEntity?;
          final BusinessEntity? business = snapshot.data![1] as BusinessEntity?;
          if (user == null || business == null) {
            return const Center(
                child: Text('User or Business data not found.'));
          }
          final AddressEntity? userAddress =
              user.address.isNotEmpty ? user.address.first : null;
          return Column(
            children: <Widget>[
              Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            business.location?.latitude ?? 40.7128,
                            business.location?.longitude ?? -74.0060,
                          ),
                          zoom: 14,
                        ),
                        markers: <Marker>{
                          Marker(
                            markerId: const MarkerId('businessLocation'),
                            position: LatLng(
                              business.location?.latitude ?? 0,
                              business.location?.longitude ?? 0,
                            ),
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
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(spacing: 10, children: <Widget>[
                          ProfilePhoto(
                            size: 24,
                            isCircle: true,
                            url: business.logo?.url,
                            placeholder: business.displayName.toString(),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  business.displayName.toString(),
                                  style: TextTheme.of(context)
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  business.location?.address ?? 'N/A',
                                  style: TextTheme.of(context)
                                      .bodySmall
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: user.profilePhotoURL != null
                              ? NetworkImage(user.profilePhotoURL!)
                              : null,
                          child: user.profilePhotoURL == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            user.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (userAddress != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              'User Location: ${userAddress.townCity}, ${userAddress.country}'),
                          Text('Street: ${userAddress.address}'),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text('Business: ${business.displayName}'),
                    Text('Business Address: ${business.address}'),
                    const SizedBox(height: 4),
                    Text("Service: ${booking.serviceID ?? 'N/A'}"),
                    Text('Time: ${booking.bookedAt.toLocal()}'),
                  ],
                ),
              ),
            ],
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
