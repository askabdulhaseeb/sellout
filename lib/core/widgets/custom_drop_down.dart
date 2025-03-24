
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    super.key,
  });
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DropdownButtonFormField<String>(
      isExpanded: true,
      padding: const EdgeInsets.all(0),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      hint: Text(
        hint,
        overflow: TextOverflow.ellipsis,
        style: textTheme.labelMedium,
      ),
      value: value,
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}