import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../features/business/core/data/sources/service/local_service.dart';
import '../../../features/business/core/domain/entity/service/service_entity.dart';
import '../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../enums/core/status_type.dart';
import '../../extension/datetime_ext.dart';
import '../../theme/colors.dart';
import '../custom_network_image.dart';

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints buiilder) {
        return buiilder.maxWidth > 100
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(width: 6, color: color),
                    Expanded(
                      child: FutureBuilder<void>(
                        future: init(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: myLightPrimaryColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${customer?.displayName} ${'with'.tr()}: ${employee?.displayName}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: boldStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  FutureBuilder<ServiceEntity?>(
                                    future: LocalService().getService(
                                        widget.booking.serviceID ?? ''),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<ServiceEntity?> snapshot,
                                    ) {
                                      final ServiceEntity? service =
                                          snapshot.data;
                                      return Text(
                                        '${service?.name} • ${widget.booking.bookedAt.timeOnly} ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    },
                                  ),
                                  const Divider(),
                                  Text(
                                    '${'status'.tr()}: ${widget.booking.status.code.tr()}',
                                    style: boldStyle.copyWith(color: color),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : FutureBuilder<ServiceEntity?>(
                future:
                    LocalService().getService(widget.booking.serviceID ?? ''),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<ServiceEntity?> snapshot,
                ) {
                  final ServiceEntity? service = snapshot.data;
                  return CircleAvatar(
                    backgroundColor: color,
                    backgroundImage: service?.thumbnailURL != null
                        ? NetworkImage(service!.thumbnailURL!)
                        : null,
                    child: CustomNetworkImage(
                      imageURL: service?.thumbnailURL,
                      color: Colors.transparent,
                    ),
                  );
                },
              );
      },
    );
  }
}
