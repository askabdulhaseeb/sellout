import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_dropdown.dart';
import '../../data/sources/local/local_dropdown_listings.dart';
import '../../domain/entities/dropdown_listings_entity.dart';

class CustomListingDropDown<T extends ChangeNotifier> extends StatefulWidget {
  const CustomListingDropDown({
    required this.categoryKey,
    required this.selectedValue,
    required this.onChanged,
    required this.validator,
    this.title = '',
    this.padding,
    this.hint = '',
    this.parentValue,
    super.key,
  });

  final String categoryKey;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String title;
  final String hint;
  final EdgeInsetsGeometry? padding;
  final String? parentValue;
  final String? Function(bool?) validator;

  @override
  State<CustomListingDropDown<T>> createState() =>
      _CustomListingDropDownState<T>();
}

class _CustomListingDropDownState<T extends ChangeNotifier>
    extends State<CustomListingDropDown<T>> {
  List<DropdownOptionEntity> options = <DropdownOptionEntity>[];
  List<DropdownOptionEntity> filteredOptions = <DropdownOptionEntity>[];
  bool isLoading = true;
  String? displayLabel;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void didUpdateWidget(covariant CustomListingDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool keyChanged = widget.categoryKey != oldWidget.categoryKey;
    final bool parentChanged = widget.parentValue != oldWidget.parentValue;
    final bool valueChanged = widget.selectedValue != oldWidget.selectedValue;

    if (keyChanged || parentChanged || valueChanged) {
      if (keyChanged || parentChanged) {
        _loadOptions();
      } else if (valueChanged) {
        _syncDisplayLabel();
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

  void _validateSelection() {
    final bool isValid = filteredOptions.any((DropdownOptionEntity opt) =>
        opt.value == widget.selectedValue ||
        _findOptionByValue(opt.children, widget.selectedValue!) != null);
    if (!isValid && widget.selectedValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(null);
      });
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
        _validateSelection();
        displayLabel = _findLabel(widget.selectedValue, options);
      });
    } catch (e) {
      debugPrint('Dropdown load error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String? _findLabel(String? value, List<DropdownOptionEntity> opts) {
    if (value == null) return null;
    for (final DropdownOptionEntity opt in opts) {
      if (opt.value == value) return opt.label;
      final String? childLabel = _findLabel(value, opt.children);
      if (childLabel != null) return childLabel;
    }
    return null;
  }

  void _syncDisplayLabel() {
    setState(() {
      displayLabel = _findLabel(widget.selectedValue, options);
    });
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
              child: Text(
                opt.label,
                style: TextTheme.of(context).bodySmall,
              ),
            ))
        .toList();

    return Consumer<T>(
      builder: (BuildContext context, T provider, _) {
        return CustomDropdown<String>(
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
