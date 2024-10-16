import 'package:flutter/material.dart';

import '../utilities/app_icons.dart';
import 'scaffold/personal_scaffold.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? 'search'.tr(),
          prefixIcon: const Icon(AppIcons.search),
          fillColor: Theme.of(context).dividerColor,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
