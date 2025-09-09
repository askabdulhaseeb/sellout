import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utilities/app_icons.dart';
import 'custom_textformfield.dart';

class SearchableTextfield extends StatefulWidget {
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
  State<SearchableTextfield> createState() => _SearchableTextfieldState();
}

class _SearchableTextfieldState extends State<SearchableTextfield> {
  Timer? _debounce;

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged?.call(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      borderRadius: 12,
      controller: widget.controller,
      onChanged: _onTextChanged,
      hint: widget.hintText ?? 'search'.tr(),
      prefixIcon: const Icon(AppIcons.search),
    );
  }
}
