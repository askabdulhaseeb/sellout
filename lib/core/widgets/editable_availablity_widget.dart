import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../features/business/core/domain/entity/routine_entity.dart';

class EditableAvailablityWidget extends StatelessWidget {
  const EditableAvailablityWidget({
    required this.title,
    required this.routine,
    super.key,
  });
  final String title;
  final List<RoutineEntity> routine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: routine.length,
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                Switch.adaptive(
                  padding: const EdgeInsets.all(0),
                  value: routine[index].isOpen,
                  onChanged: (bool value) {},
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    routine[index].day.code.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  routine[index].displayStr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
