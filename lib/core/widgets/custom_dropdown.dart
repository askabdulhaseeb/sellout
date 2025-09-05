import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'custom_textformfield.dart';

class CustomDropdown<T> extends FormField<T> {
  CustomDropdown({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required String? Function(bool?) validator,
    this.hint,
    this.width,
    this.height,
    this.searchBy,
    super.key,
  }) : super(
          validator: (val) => validator(val != null),
          initialValue: selectedItem,
          builder: (FormFieldState<T> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TypeAheadField<DropdownMenuItem<T>>(
                  decorationBuilder: (BuildContext context, Widget child) {
                    return Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: child,
                    );
                  },
                  suggestionsCallback: (String pattern) {
                    if (pattern.isEmpty) return items;
                    return items.where((DropdownMenuItem<T> item) {
                      final String text = searchBy != null
                          ? searchBy(item)
                          : item.child is Text
                              ? (item.child as Text).data ?? ''
                              : item.value.toString();
                      return text.toLowerCase().contains(pattern.toLowerCase());
                    }).toList();
                  },
                  builder: (BuildContext context,
                      TextEditingController controller, FocusNode focusNode) {
                    String selectedText = '';
                    final DropdownMenuItem<T> selectedItem = items.firstWhere(
                      (DropdownMenuItem<T> element) =>
                          element.value == state.value,
                      orElse: () => DropdownMenuItem<T>(
                          value: null, child: const SizedBox()),
                    );
                    if (selectedItem.value != null) {
                      if (selectedItem.child is Text) {
                        selectedText = (selectedItem.child as Text).data ?? '';
                      } else {
                        selectedText = selectedItem.value.toString();
                      }
                    }
                    controller.text = selectedText;

                    return CustomTextFormField(
                      hint: hint ?? 'select_item'.tr(),
                      controller: controller,
                      focusNode: focusNode,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    );
                  },
                  itemBuilder:
                      (BuildContext context, DropdownMenuItem<T> suggestion) =>
                          Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: suggestion.child,
                  ),
                  onSelected: (DropdownMenuItem<T> suggestion) {
                    state.didChange(suggestion.value);
                    onChanged?.call(suggestion.value);
                  },
                  emptyBuilder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('no_data_found'.tr(),
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                  debounceDuration: const Duration(milliseconds: 300),
                ),
              ],
            );
          },
        );

  final String title;
  final List<DropdownMenuItem<T>> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final String? hint;
  final double? width;
  final double? height;
  final String Function(DropdownMenuItem<T>)? searchBy; // new
}
