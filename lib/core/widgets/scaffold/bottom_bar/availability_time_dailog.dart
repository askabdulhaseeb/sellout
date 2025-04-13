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
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: _TimeDropdown(
                    value: entity.openingTime,
                    hint: 'start_time'.tr(),
                    items: timeSlots,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.updateOpeningTime(entity.day, newValue);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: _TimeDropdown(
                    value: entity.closingTime,
                    hint: 'end_time'.tr(),
                    items: timeSlots,
                    enabledItems: (String item) {
                      if (entity.openingTime.isEmpty) return false;
                      return provider.isClosingTimeValid(
                          entity.openingTime, item);
                    },
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.setClosingTime(entity.day, newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              onTap: () => Navigator.pop(context),
              isLoading: false,
              title: 'done'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.enabledItems,
  });

  final String? value;
  final String hint;
  final List<String> items;
  final bool Function(String)? enabledItems;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      title: hint,
      validator: (bool? value) {
        return null;
      },
      selectedItem: value ?? hint, // Default to hint if null
      hint: hint,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          enabled: enabledItems == null ? true : enabledItems!(item),
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
