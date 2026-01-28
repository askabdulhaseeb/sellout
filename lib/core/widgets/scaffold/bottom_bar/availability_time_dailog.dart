import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../features/personal/post/domain/entities/meetup/availability_entity.dart';
import '../../buttons/custom_elevated_button.dart';
import '../../inputs/custom_dropdown.dart';

class AvailabilityTimeDialog extends StatefulWidget {
  const AvailabilityTimeDialog({required this.entity, super.key});

  final AvailabilityEntity entity;

  @override
  State<AvailabilityTimeDialog> createState() => _AvailabilityTimeDialogState();
}

class _AvailabilityTimeDialogState extends State<AvailabilityTimeDialog> {
  String? _selectedStartTime;
  String? _selectedEndTime;

  @override
  void initState() {
    super.initState();
    _selectedStartTime = widget.entity.openingTime.isNotEmpty
        ? widget.entity.openingTime
        : null;
    _selectedEndTime = widget.entity.closingTime.isNotEmpty
        ? widget.entity.closingTime
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider provider = Provider.of<AddListingFormProvider>(
      context,
      listen: false,
    );
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
            Row(
              children: <Widget>[
                const CloseButton(),
                Text(
                  'set_time_range'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<String>(
                    title: 'start_time'.tr(),
                    selectedItem: _selectedStartTime,
                    hint: 'start_time'.tr(),
                    validator: (_) => null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStartTime = newValue;
                        // reset end time if invalid
                        if (_selectedEndTime != null &&
                            !provider.isClosingTimeValid(
                              _selectedStartTime!,
                              _selectedEndTime!,
                            )) {
                          _selectedEndTime = null;
                        }
                      });
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
                    title: 'end_time'.tr(),
                    selectedItem: _selectedEndTime,
                    hint: 'end_time'.tr(),
                    validator: (_) => null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEndTime = newValue;
                      });
                    },
                    items: timeSlots.map((String item) {
                      final bool isEnabled = _selectedStartTime == null
                          ? false
                          : provider.isClosingTimeValid(
                              _selectedStartTime!,
                              item,
                            );
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
                onTap: () {
                  if (_selectedStartTime != null) {
                    provider.updateOpeningTime(
                      widget.entity.day,
                      _selectedStartTime!,
                    );
                  }
                  if (_selectedEndTime != null) {
                    provider.setClosingTime(
                      widget.entity.day,
                      _selectedEndTime!,
                    );
                  }
                  Navigator.pop(context);
                },
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
