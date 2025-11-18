import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../features/personal/chats/quote/domain/entites/time_slot_entity.dart';

class CreateBookingSlotsWithEntity extends StatelessWidget {
  const CreateBookingSlotsWithEntity({
    required this.slots,
    required this.selectedTime,
    required this.onSlotSelected,
    this.height = 36,
    this.isLoading = false,
    super.key,
  });

  final List<SlotEntity> slots;
  final String? selectedTime;
  final ValueChanged<String?> onSlotSelected;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Loading state
    if (isLoading) {
      return _loadingSkeleton(theme);
    }

    // Empty state
    if (slots.isEmpty) {
      return Text('no_available_slots'.tr());
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: slots.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildSlot(context, slots[index]),
      ),
    );
  }

  Widget _loadingSkeleton(ThemeData theme) => SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: 6,
          itemBuilder: (_, __) => Container(
            width: 80,
            height: height,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  Widget _buildSlot(BuildContext context, SlotEntity slot) {
    final ThemeData theme = Theme.of(context);
    final bool isSelected = selectedTime == slot.time;
    final bool isBooked = slot.isBooked;

    // Colors
    final Color availableColor = theme.dividerColor;
    final Color selectedColor = theme.primaryColor;
    final Color bookedColor = theme.disabledColor.withValues(alpha: 0.2);

    return Tooltip(
      message: isBooked ? 'slot_booked'.tr() : slot.time,
      waitDuration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: isBooked
            ? null
            : () => onSlotSelected(isSelected ? null : slot.time),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 80,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isBooked
                ? bookedColor
                : (isSelected ? selectedColor : availableColor),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: !isSelected
                  ? theme.colorScheme.outlineVariant
                  : Colors.transparent,
            ),
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: theme.dividerColor,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : <BoxShadow>[],
          ),
          child: Text(
            slot.time,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isBooked
                  ? theme.colorScheme.error.withValues(alpha: 0.6)
                  : (isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface),
              decoration: isBooked ? TextDecoration.lineThrough : null,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
