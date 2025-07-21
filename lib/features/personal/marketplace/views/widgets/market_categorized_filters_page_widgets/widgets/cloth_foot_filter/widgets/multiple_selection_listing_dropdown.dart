import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/custom_multi_selection_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_dropdown_listings.dart';
import '../../../../../../../listing/listing_form/domain/entities/dropdown_listings_entity.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CustomListingMultiDropdown<T extends ChangeNotifier>
    extends StatefulWidget {
  const CustomListingMultiDropdown({
    required this.categoryKey,
    required this.selectedValues,
    required this.onChanged,
    this.title = '',
    this.padding,
    this.hint = '',
    this.parentValue,
    super.key,
  });

  final String categoryKey;
  final List<String> selectedValues;
  final void Function(List<String>) onChanged;
  final String title;
  final String hint;
  final EdgeInsetsGeometry? padding;
  final String? parentValue;

  @override
  State<CustomListingMultiDropdown<T>> createState() =>
      _CustomListingMultiDropdownState<T>();
}

class _CustomListingMultiDropdownState<T extends ChangeNotifier>
    extends State<CustomListingMultiDropdown<T>> {
  List<DropdownOptionEntity> options = <DropdownOptionEntity>[];
  List<DropdownOptionEntity> filteredOptions = <DropdownOptionEntity>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void didUpdateWidget(covariant CustomListingMultiDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool keyChanged = widget.categoryKey != oldWidget.categoryKey;
    final bool parentChanged = widget.parentValue != oldWidget.parentValue;
    final bool valueChanged = widget.selectedValues != oldWidget.selectedValues;

    if (keyChanged || parentChanged || valueChanged) {
      if (keyChanged || parentChanged) {
        _loadOptions();
      }
    }
  }

  DropdownOptionEntity? _findOptionByValue(
      List<DropdownOptionEntity> opts, String value) {
    for (final DropdownOptionEntity opt in opts) {
      if (opt.value == value) return opt;
      final DropdownOptionEntity? found =
          _findOptionByValue(opt.children, value);
      if (found != null) return found;
    }
    return null;
  }

  void _filterOptions() {
    if (widget.parentValue != null) {
      final DropdownOptionEntity? parentOption =
          _findOptionByValue(options, widget.parentValue!);
      filteredOptions = parentOption?.children ?? <DropdownOptionEntity>[];
    } else {
      filteredOptions = options;
    }
  }

  Future<void> _loadOptions() async {
    setState(() => isLoading = true);

    try {
      final Box<DropdownCategoryEntity> box =
          Hive.box<DropdownCategoryEntity>(LocalDropDownListings.boxTitle);
      final DropdownCategoryEntity? category = box.get(widget.categoryKey);
      setState(() {
        options = category?.options ?? <DropdownOptionEntity>[];
        _filterOptions();
      });
    } catch (e) {
      debugPrint('Dropdown load error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
    }

    // Map DropdownOptionEntity to DropdownMenuItem<String>
    final List<DropdownMenuItem<String>> dropdownItems = filteredOptions
        .map((DropdownOptionEntity opt) => DropdownMenuItem<String>(
              value: opt.value,
              child: Text(opt.label),
            ))
        .toList();
    return Consumer<T>(
      builder: (BuildContext context, T provider, _) {
        return MultiSelectionDropdown<String>(
          title: widget.title,
          hint: widget.hint,
          selectedItems: widget.selectedValues,
          onChanged: widget.onChanged,
          items: dropdownItems,
        );
      },
    );
  }
}
