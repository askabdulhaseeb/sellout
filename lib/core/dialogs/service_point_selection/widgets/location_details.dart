import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';
import '../../../constants/app_spacings.dart';

class LocationDetails extends StatelessWidget {
  const LocationDetails({required this.point, super.key});

  final ServicePointModel point;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    point.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildBadge(point.distance.toString(), colorScheme.secondary),
              ],
            ),
            const SizedBox(height: 4),
            _buildBadge(point.type, colorScheme.tertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${point.address}${', ${point.city}'}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'opening_hours'.tr(),
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _OpeningHoursTable(openingHours: point.openingHours),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OpeningHoursTable extends StatelessWidget {
  const _OpeningHoursTable({required this.openingHours});

  final Map<String, List<String>> openingHours;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<MapEntry<String, List<String>>> entries = openingHours.entries
        .toList();
    final int currentDay = DateTime.now().weekday % 7;

    return Column(
      children: entries.map((MapEntry<String, List<String>> entry) {
        final int dayIndex = int.tryParse(entry.key) ?? -1;
        final bool isToday = dayIndex == currentDay;
        final String dayName = _getDayName(dayIndex);
        final String times = entry.value.join(', ');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Text(
                  dayName,
                  style: textTheme.bodySmall?.copyWith(
                    color: isToday
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  times,
                  textAlign: TextAlign.end,
                  style: textTheme.bodySmall?.copyWith(
                    color: isToday
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getDayName(int dayIndex) {
    const List<String> dayKeys = <String>[
      'sun',
      'mon',
      'tue',
      'wed',
      'thu',
      'fri',
      'sat',
    ];

    if (dayIndex >= 0 && dayIndex < dayKeys.length) {
      return dayKeys[dayIndex].tr();
    }
    return dayIndex.toString();
  }
}
