import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utilities/app_icons.dart';

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
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintStyle: TextTheme.of(context)
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.outlineVariant),
          hintText: hintText ?? 'search'.tr(),
          prefixIcon: const Icon(AppIcons.search),
          fillColor: Theme.of(context).primaryColor,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(4.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
