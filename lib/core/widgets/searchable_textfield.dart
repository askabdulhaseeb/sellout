import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utilities/app_icons.dart';
import 'custom_textformfield.dart';

class SearchableTextfield extends StatelessWidget {
  const SearchableTextfield({
    this.controller,
    this.hintText,
    this.onChanged,
    super.key,
  });
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      borderRadius: 12,
      controller: controller,
      onChanged: onChanged,
      hint: hintText ?? 'search'.tr(),
      prefixIcon: const Icon(AppIcons.search),
    );
  }
}
