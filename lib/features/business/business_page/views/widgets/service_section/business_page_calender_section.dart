import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/calender/calender_widget.dart';
import '../../../../../personal/bookings/data/sources/local_booking.dart';
import '../../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../../../../core/domain/entity/business_entity.dart';
import '../../providers/business_page_provider.dart';
import '../business_page_employee_list_section.dart';

class BusinessPageCalenderSection extends StatelessWidget {
  const BusinessPageCalenderSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPageProvider>(
      builder: (BuildContext context, BusinessPageProvider pagePro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BusinessPageEmployeeListSection(business: business),
            const SizedBox(height: 16),
            Flexible(
              child: FutureBuilder<DataState<List<BookingEntity>>>(
                future: pagePro.getBookings(business.businessID),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DataState<List<BookingEntity>>> snapshot,
                ) {
                  final List<BookingEntity> bookings = kDebugMode
                      ? LocalBooking().all
                      : snapshot.data?.entity ?? <BookingEntity>[];
                  return CalenderWidget(business: business, bookings: bookings);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
