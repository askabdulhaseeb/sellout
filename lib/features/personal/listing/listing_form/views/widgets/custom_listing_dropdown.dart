import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/custom_dropdown.dart';

class CustomListingDropDown<T extends ChangeNotifier, O>
    extends StatefulWidget {
  const CustomListingDropDown({
    required this.options,
    required this.valueGetter,
    required this.labelGetter,
    required this.selectedValue,
    required this.onChanged,
    required this.validator,
    this.title = '',
    this.padding,
    this.hint = '',
    this.parentValue,
    this.overlayAbove = false,
    super.key,
  });

  final List<O> options;
  final String Function(O) valueGetter;
  final String Function(O) labelGetter;

  final String? selectedValue;
  final void Function(String?) onChanged;
  final String title;
  final String hint;
  final EdgeInsetsGeometry? padding;
  final String? parentValue;
  final bool overlayAbove;
  final String? Function(bool?) validator;

  @override
  State<CustomListingDropDown<T, O>> createState() =>
      _CustomListingDropDownState<T, O>();
}

class _CustomListingDropDownState<T extends ChangeNotifier, O>
    extends State<CustomListingDropDown<T, O>> {
  late List<O> filteredOptions;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
  }

  @override
  void didUpdateWidget(covariant CustomListingDropDown<T, O> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      filteredOptions = widget.options;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> dropdownItems = filteredOptions
        .map(
          (O opt) => DropdownMenuItem<String>(
            value: widget.valueGetter(opt),
            child: Text(
              widget.labelGetter(opt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        )
        .toList();

    return Consumer<T>(
      builder: (BuildContext context, T provider, _) {
        return CustomDropdown<String>(
          overlayAbove: widget.overlayAbove,
          title: widget.title,
          items: dropdownItems,
          selectedItem: widget.selectedValue,
          onChanged: widget.onChanged,
          validator: widget.validator,
          hint: widget.hint,
        );
      },
    );
  }
}
