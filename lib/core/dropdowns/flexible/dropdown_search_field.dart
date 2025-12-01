import 'package:flutter/material.dart';
import '../../widgets/custom_textformfield.dart';

class DropdownSearchField extends StatelessWidget {
  const DropdownSearchField({
    required this.controller,
    required this.onChanged,
    this.hintText,
    super.key,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTextFormField(
        controller: controller,
        autoFocus: true,
        onChanged: onChanged,
      ),
    );
  }
}
