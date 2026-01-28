import 'package:flutter/material.dart';

class CustomRadioToggleTile extends StatelessWidget {
  const CustomRadioToggleTile({
    required this.selectedValue,
    required this.onChanged,
    required this.title,
    super.key,
  });
  final bool selectedValue;
  final Function
      onChanged; // The function type should be just Function, not Function<void>
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 2,
      contentPadding: const EdgeInsets.all(2),
      title: Text(
        title,
        style: TextTheme.of(context).bodyMedium,
      ),
      leading: InkWell(
        child: Icon(
          selectedValue ? Icons.check_box : Icons.check_box_outline_blank,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () => onChanged(), // Invoke the function here
      ),
    );
  }
}
