import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entity/routine_entity.dart';

class BusinessHoursDisplaySection extends StatelessWidget {
  const BusinessHoursDisplaySection({required this.routine, super.key});
  final List<RoutineEntity> routine;

  @override
  Widget build(BuildContext context) {
    dayStyle(RoutineEntity day) => TextStyle(
          color: day.isOpen
              ? day.isToday
                  ? Theme.of(context).colorScheme.secondary
                  : null
              : Theme.of(context).primaryColor,
          fontWeight: day.isOpen && !day.isToday ? null : FontWeight.bold,
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'business_hours',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 8),
        for (final RoutineEntity day in routine)
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  day.isToday
                      ? '${day.day.code.tr()} (${'today'.tr()})'
                      : day.day.code.tr(),
                  style: dayStyle(day),
                ),
              ),
              if (!day.isOpen) Text('closed', style: dayStyle(day)).tr(),
              Text(day.opening?.trim() ?? '', style: dayStyle(day)),
              if (day.isOpen) Text(' - ', style: dayStyle(day)),
              Text(day.closing?.trim() ?? '', style: dayStyle(day)),
            ],
          ),
      ],
    );
  }
}
