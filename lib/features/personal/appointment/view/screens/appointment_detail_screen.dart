import 'package:flutter/material.dart';
import '../../../../business/core/data/sources/local_business.dart';
import '../../../../business/core/data/sources/service/local_service.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../widgets/appointment_tile_buttons/appointment_tile_payment_buttons.dart';
import '../widgets/business_detail_widgets/appointment_detail_description.dart';
import '../widgets/business_detail_widgets/appointment_detail_map.dart';
import '../widgets/appointment_tile_buttons/appointment_tile_update_button_section.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({
    required this.bookings,
    super.key,
  });

  final List<BookingEntity> bookings;

  BookingEntity get booking => bookings.first;

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
          future: Future.wait(<Future<dynamic>>[
            _getUser(),
            _getBusiness(),
            _getService(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text(''));
            }
            final UserEntity? user = snapshot.data![0] as UserEntity?;
            final BusinessEntity? business =
                snapshot.data![1] as BusinessEntity?;
            final ServiceEntity? service = snapshot.data![2] as ServiceEntity?;
            if (user == null || business == null) {
              return const Center(child: Text(''));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppointmentMapSection(business: business),
                  const SizedBox(height: 12),
                  ...bookings.map(
                    (BookingEntity b) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppointmentDescriptionSection(
                        business: business,
                        service: service,
                        user: user,
                        booking: b,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (bookings.length == 1)
                AppointmentTileUpdateButtonSection(booking: booking),
              AppointmentTilePaymentButtons(booking: bookings)
            ],
          ),
        ));
  }
}
