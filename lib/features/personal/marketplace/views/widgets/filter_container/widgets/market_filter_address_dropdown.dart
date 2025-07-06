import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../providers/marketplace_provider.dart';

class AddedFilterDropdown extends StatelessWidget {
  const AddedFilterDropdown({super.key});

  static final Map<String, Duration> _options = <String, Duration>{
    'today': const Duration(days: 1),
    '7_days': const Duration(days: 7),
    '30_days': const Duration(days: 30),
    '90_days': const Duration(days: 90),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, _) {
        return CustomDropdown<String>(
          title: '',
          hint: 'added_to_site'.tr(),
          items: _options.keys
              .map(
                (String key) => DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    key.tr(),
                    style: TextTheme.of(context).bodyMedium,
                  ),
                ),
              )
              .toList(),
          selectedItem: marketPro.addedFilterKey,
          onChanged: (String? p0) =>
              marketPro.setAddedFilterKey(getCreatedAfterDateString(p0)),
          validator: (_) => null,
        );
      },
    );
  }

  static DateTime? getCreatedAfterDate(String? key) {
    if (key == null || !_options.containsKey(key)) return null;
    return DateTime.now().subtract(_options[key]!);
  }

  static String? getCreatedAfterDateString(String? key) {
    final DateTime? date = getCreatedAfterDate(key);
    if (date == null) return null;
    // Example: Wed Jun 18 2025 14:56:18 GMT+0000
    final DateFormat formatter =
        DateFormat('EEE MMM dd yyyy HH:mm:ss', 'en_US');
    final String formatted = formatter.format(date.toUtc());

    return '$formatted GMT+0000';
  }
}
