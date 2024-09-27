import 'package:flutter/material.dart';

class CustomRadioButtonListTile<T> extends StatelessWidget {
  const CustomRadioButtonListTile({
    required this.title,
    required this.selectedValue,
    required this.value,
    required this.onChanged,
    this.subtitle,
    super.key,
  });
  final String title;
  final T selectedValue;
  final T value;
  final void Function(T) onChanged;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 8)
            : const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(title),
              ],
            ),
            if (subtitle != null && isSelected)
              subtitle ?? const Text('Something went wrong'),
          ],
        ),
      ),
    );
  }
}
