import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../features/personal/post/domain/entities/meetup/availability_entity.dart';
import '../../custom_dropdown.dart';
import '../../custom_elevated_button.dart';

class AvailabilityTimeDialog extends StatelessWidget {
  const AvailabilityTimeDialog({
    required this.entity,
    super.key,
  });

  final AvailabilityEntity entity;

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider provider =
        Provider.of<AddListingFormProvider>(context, listen: false);
    final List<String> timeSlots = provider.generateTimeSlots();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'set_time_range'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<String>(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    title: 'start_time'.tr(),
                    selectedItem: entity.openingTime.isNotEmpty
                        ? entity.openingTime
                        : null,
                    hint: 'start_time'.tr(),
                    validator: (_) => null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.updateOpeningTime(entity.day, newValue);
                      }
                    },
                    items: timeSlots.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDropdown<String>(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    title: 'end_time'.tr(),
                    selectedItem: entity.closingTime.isNotEmpty
                        ? entity.closingTime
                        : null,
                    hint: 'end_time'.tr(),
                    validator: (_) => null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.setClosingTime(entity.day, newValue);
                      }
                    },
                    items: timeSlots.map((String item) {
                      final bool isEnabled = entity.openingTime.isEmpty
                          ? false
                          : provider.isClosingTimeValid(
                              entity.openingTime, item);
                      return DropdownMenuItem<String>(
                        value: item,
                        enabled: isEnabled,
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onTap: () => Navigator.pop(context),
                isLoading: false,
                title: 'done'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
