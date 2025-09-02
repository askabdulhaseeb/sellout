import 'package:flutter/material.dart';
import '../../../../business/core/data/sources/local_business.dart';
import '../../../../business/core/data/sources/service/local_service.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../widgets/appointment_tile_button_section.dart';
import '../widgets/business_detail_widgets/appointment_detail_description.dart';
import '../widgets/business_detail_widgets/appointment_detail_map.dart';

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
