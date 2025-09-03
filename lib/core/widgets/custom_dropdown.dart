import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'custom_textformfield.dart';

class CustomDropdown<T> extends FormField<bool> {
  CustomDropdown({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required FormFieldValidator<bool> validator,
    this.isSearchable = false,
    this.padding,
    this.height,
    this.width,
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
                  padding: padding,
                  height: height,
                  isSearchable: isSearchable,
                  width: width,
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
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool isSearchable;

  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return _Widget(
      title: title,
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      padding: padding,
      height: height,
      isSearchable: isSearchable,
      width: width,
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
    this.isSearchable = true,
    this.padding,
    this.height,
    this.width,
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
  final double? height;
  final double? width;
  final bool isSearchable;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          width: width ?? double.infinity,
          height: height ?? 48,
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.color,
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              // width: 0.5,
              color: ColorScheme.of(context).outlineVariant,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: items.isEmpty
                      ? ColorScheme.of(context).outlineVariant
                      : ColorScheme.of(context).outline,
                ),
              ),
              isExpanded: true,
              hint: Text(
                hint ?? 'select_item',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context)
                    .bodyMedium
                    ?.copyWith(color: ColorScheme.of(context).outline),
              ).tr(),
              items: items.isEmpty ? <DropdownMenuItem<T>>[] : items,
              value: selectedItem,
              onChanged: onChanged,
              buttonStyleData: ButtonStyleData(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
              ),
              dropdownSearchData: isSearchable == false
                  ? null
                  : DropdownSearchData<T>(
                      searchController: _search,
                      searchInnerWidgetHeight: 70,
                      searchInnerWidget: CustomTextFormField(
                        fieldPadding: const EdgeInsets.all(4),
                        dense: true,
                        style: TextTheme.of(context).labelMedium,
                        contentPadding: const EdgeInsets.all(4),
                        controller: _search,
                        isExpanded: true,
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
              style: TextTheme.of(context).bodyMedium,
              dropdownStyleData: DropdownStyleData(
                  elevation: 0,
                  maxHeight: 250,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Theme.of(context).scaffoldBackgroundColor)
                      ],
                      borderRadius: BorderRadius.circular(8),
                      backgroundBlendMode: BlendMode.color,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                          color: ColorScheme.of(context)
                              .outline
                              .withValues(alpha: 0.2))),
                  offset: const Offset(0, 0),
                  isOverButton: false),
              menuItemStyleData: const MenuItemStyleData(
                height: 60,
              ),
            ),
          ),
        )
      ],
    );
  }
}
