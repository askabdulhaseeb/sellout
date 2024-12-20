import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../enums/core/status_type.dart';

class CalenderBookingTile extends StatefulWidget {
  const CalenderBookingTile({required this.booking, super.key});
  final BookingEntity booking;

  @override
  State<CalenderBookingTile> createState() => _CalenderBookingTileState();
}

class _CalenderBookingTileState extends State<CalenderBookingTile> {
  UserEntity? customer;
  UserEntity? employee;

  Future<void> init() async {
    customer = await LocalUser().user(widget.booking.customerID);
    employee = await LocalUser().user(widget.booking.employeeID);
  }

  @override
  Widget build(BuildContext context) {
    final Color color =
        widget.booking.status == StatusType.pending ? Colors.red : Colors.green;
    const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.w700);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(width: 6, color: color),
          Expanded(
            child: FutureBuilder<void>(
              future: init(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: color.withValues(
                      alpha: 0.3, red: 0.8, green: 0.5, blue: 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${customer?.displayName} ${'with'.tr()}: ${employee?.displayName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: boldStyle,
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
