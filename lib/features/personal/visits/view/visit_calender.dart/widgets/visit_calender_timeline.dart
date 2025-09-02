import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../providers/visit_calender_provider.dart';
import 'visit_calender_tile.dart';

class VisitTimeline extends StatelessWidget {
  const VisitTimeline({
    required this.visits,
    super.key,
  });
  final List<VisitingEntity> visits;

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitCalenderProvider>(
      builder:
          (BuildContext context, VisitCalenderProvider pro, Widget? child) =>
              SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 48, // 30-minute slots
          itemBuilder: (BuildContext context, int index) {
            final int hour = index ~/ 2; // integer division
            final int minute = (index % 2) * 30;
            final String timeLabel =
                '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

            final List<VisitingEntity> visitsAtSlot = visits
                .where((VisitingEntity v) =>
                    v.dateTime.hour == hour &&
                    v.dateTime.minute ~/ 30 == minute ~/ 30 && // match 0 or 30
                    isSameDay(v.dateTime, pro.selecteddate))
                .toList();

            final VisitingEntity? visit =
                visitsAtSlot.isNotEmpty ? visitsAtSlot.first : null;

            return SizedBox(
              height: 90,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      left: 0, top: 0, bottom: 0, child: Text(timeLabel)),
                  if (visit != null)
                    Positioned(
                      top: 10,
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: VisitCalenderTile(visit: visit),
                    ),
                  Positioned(
                    left: 40,
                    top: 0,
                    right: 10,
                    child: Divider(color: Theme.of(context).dividerColor),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
