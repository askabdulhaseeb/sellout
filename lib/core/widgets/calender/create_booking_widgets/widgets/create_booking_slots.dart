import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateBookingSlots extends StatelessWidget {
  const CreateBookingSlots({
    required this.slots,
    required this.selectedTime,
    required this.onSlotSelected,
    this.height = 56,
    this.isLoading = false,
    super.key,
  });

  final List<Map<String, dynamic>> slots;
  final String? selectedTime;
  final ValueChanged<String?> onSlotSelected;
  final double height;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: 6, // number of skeleton chips
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 80,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        ),
      );
    }
    if (slots.isEmpty) {
      return Text('no_available_slots'.tr());
    }
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: slots.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> slot = slots[index];
          final String time = slot['time'] as String;
          final bool isBooked = slot['isBooked'] as bool;
          final bool isSelected = selectedTime == time;

          // Colors
          final Color availableColor = Theme.of(context).colorScheme.surface;
          final Color selectedColor = Theme.of(context).colorScheme.primary;
          final Color bookedColor =
              Theme.of(context).disabledColor.withValues(alpha: 0.2);

          return Tooltip(
            message: isBooked ? 'slot_booked'.tr() : time,
            waitDuration: const Duration(milliseconds: 500),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: ChoiceChip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                showCheckmark: false,
                label: Text(
                  time,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isBooked
                        ? Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.6)
                        : (isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface),
                    decoration: isBooked ? TextDecoration.lineThrough : null,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: isBooked
                    ? null
                    : (bool selected) {
                        onSlotSelected(selected ? time : null);
                      },
                selectedColor: selectedColor,
                backgroundColor: isBooked ? bookedColor : availableColor,
                disabledColor: bookedColor,
                elevation: 0,
              ),
            ),
          );
        },
      ),
    );
  }
}
