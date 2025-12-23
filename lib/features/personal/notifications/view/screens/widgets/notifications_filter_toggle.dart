import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../domain/enums/notification_type.dart';

class NotificationsFilterToggle extends StatelessWidget {
  const NotificationsFilterToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final NotificationType value;
  final ValueChanged<NotificationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomToggleSwitch<NotificationType>(
      isShaded: false,
      borderWidth: 1,
      unseletedBorderColor: ColorScheme.of(context).outlineVariant,
      unseletedTextColor: ColorScheme.of(context).onSurface,
      borderRad: 6,
      labels: NotificationType.values.toList(),
      labelStrs: NotificationType.values
          .map((NotificationType e) => e.code.tr())
          .toList(),
      labelText: '',
      initialValue: value,
      onToggle: onChanged,
      selectedColors: List<Color>.filled(
        NotificationType.values.length,
        Theme.of(context).primaryColor,
      ),
    );
  }
}
