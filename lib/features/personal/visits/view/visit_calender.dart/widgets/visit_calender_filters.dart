import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visit_calender_provider.dart';

class VisitCalendarFilters extends StatelessWidget {
  const VisitCalendarFilters({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<VisitCalenderProvider>(
      builder:
          (BuildContext context, VisitCalenderProvider pro, Widget? child) =>
              Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            // Date picker
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: pro.selecteddate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) pro.setSelectedDate(picked);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant)),
                child: Row(
                  children: <Widget>[
                    Text(
                      DateFormat.yMMMMd().format(pro.selecteddate),
                      style: TextTheme.of(context).bodySmall,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
