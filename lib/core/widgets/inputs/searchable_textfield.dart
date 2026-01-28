import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../utilities/app_icons.dart';
import 'custom_textformfield.dart';

class SearchableTextfield extends StatefulWidget {
  const SearchableTextfield({
    this.controller,
    this.hintText,
    this.onChanged,
    this.borderRadius,
    this.border,
    this.padding,
    this.focusNode,
    this.autoFocus,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final double? borderRadius;
  final InputBorder? border;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final bool? autoFocus;

  @override
  State<SearchableTextfield> createState() => _SearchableTextfieldState();
}

class _SearchableTextfieldState extends State<SearchableTextfield> {
  Timer? _debounce;

  void _onTextChanged(String value) {
    // cancel any existing timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // start a new timer with 600ms delay
    _debounce = Timer(const Duration(milliseconds: 600), () {
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
      autoFocus: widget.autoFocus ?? false,
      focusNode: widget.focusNode,
      fieldPadding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8),
      border: widget.border,
      borderRadius: widget.borderRadius ?? 12,
      controller: widget.controller,
      onChanged: _onTextChanged,
      hint: widget.hintText ?? 'search'.tr(),
      prefixIcon: const Icon(AppIcons.search),
    );
  }
}
