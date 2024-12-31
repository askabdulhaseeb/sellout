import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends FormField<bool> {
  CustomDropdown({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required FormFieldValidator<bool> validator,
    this.padding,
    this.hint,
    super.key,
  }) : super(
          validator: validator,
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ignore: always_specify_types
                _Widget(
                  title: title,
                  items: items,
                  selectedItem: selectedItem,
                  onChanged: onChanged,
                  hint: hint,
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );

  final String title;
  final void Function(T?)? onChanged;
  final T? selectedItem;
  final List<DropdownMenuItem<T>> items;
  final String? hint;
  final EdgeInsetsGeometry? padding;

  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return _Widget(
      title: title,
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      hint: hint,
    );
  }
}

class _Widget<T> extends StatelessWidget {
  _Widget({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.padding,
    this.hint,
    super.key,
  });
  final String title;
  final void Function(T?)? onChanged;
  final T? selectedItem;
  final List<DropdownMenuItem<T>> items;
  final TextEditingController _search = TextEditingController();
  final EdgeInsetsGeometry? padding;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? kDebugMode
            ? Text('$title is disabled - display only in testing Mode')
            : const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 0.5,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<T>(
                    isExpanded: true,
                    hint: Text(
                      hint ?? 'select-item'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items,
                    value: selectedItem,
                    onChanged: onChanged,
                    buttonStyleData: ButtonStyleData(
                      padding:
                          padding ?? const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    dropdownSearchData: DropdownSearchData<T>(
                      searchController: _search,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _search,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Search for an item...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      searchMatchFn: (
                        DropdownMenuItem<T> item,
                        String searchValue,
                      ) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .trim()
                            .contains(searchValue.toLowerCase().trim());
                      },
                    ),
                    menuItemStyleData: const MenuItemStyleData(height: 40),
                  ),
                ),
              ),
            ],
          );
  }
}
