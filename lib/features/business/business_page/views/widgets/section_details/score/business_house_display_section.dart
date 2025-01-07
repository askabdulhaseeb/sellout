import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entity/routine_entity.dart';

class BusinessHoursDisplaySection extends StatelessWidget {
  const BusinessHoursDisplaySection({required this.routine, super.key});
  final List<RoutineEntity> routine;

  @override
  Widget build(BuildContext context) {
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
                  day.day.code,
                  style: TextStyle(
                    color: day.isOpen ? null : Theme.of(context).primaryColor,
                    fontWeight: day.isOpen ? null : FontWeight.bold,
                  ),
                ).tr(),
              ),
              if (!day.isOpen)
                Text(
                  'closed',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
              Text(day.opening?.trim() ?? ''),
              if (day.isOpen) const Text(' - '),
              Text(day.closing?.trim() ?? ''),
            ],
          ),
      ],
    );
  }
}
