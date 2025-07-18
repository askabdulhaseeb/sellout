import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../data/sources/local/local_dropdown_listings.dart';
import '../../domain/entities/dropdown_listings_entity.dart';

class CustomListingDropDown<T extends ChangeNotifier> extends StatefulWidget {
  const CustomListingDropDown({
    required this.categoryKey,
    required this.selectedValue,
    required this.onChanged,
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

    return Consumer<T>(
      builder: (BuildContext context, provider, _) {
        return Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.title.isNotEmpty) ...<Widget>[
                Text(
                  widget.title.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
              ],
              GestureDetector(
                onTap: _showPicker,
                child: InputDecorator(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: ColorScheme.of(context).outlineVariant,
                      ),
                    ),
                    hintText: widget.hint.tr(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorScheme.of(context).outlineVariant,
                        ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorScheme.of(context).outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          displayLabel ?? widget.hint.tr(),
                          overflow: TextOverflow.ellipsis,
                          style: displayLabel != null
                              ? null
                              : TextStyle(
                                  color: ColorScheme.of(context).outlineVariant,
                                ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: ColorScheme.of(context).outline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPicker() async {
    final DropdownOptionEntity? result =
        await showModalBottomSheet<DropdownOptionEntity>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (BuildContext context) => _OptionsPicker(
        title: widget.title,
        options: filteredOptions,
      ),
    );

    if (result != null) {
      widget.onChanged(result.value);
    }
  }
}

class _OptionsPicker extends StatelessWidget {
  const _OptionsPicker({required this.title, required this.options});
  final String title;
  final List<DropdownOptionEntity> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final DropdownOptionEntity opt = options[index];
                return ListTile(
                  title: Text(opt.label),
                  trailing: opt.children.isNotEmpty
                      ? const Icon(Icons.chevron_right)
                      : null,
                  onTap: () async {
                    if (opt.children.isNotEmpty) {
                      final DropdownOptionEntity? childResult =
                          await showModalBottomSheet<DropdownOptionEntity>(
                        context: context,
                        builder: (BuildContext ctx) => _OptionsPicker(
                          title: opt.label,
                          options: opt.children,
                        ),
                      );
                      if (childResult != null) {
                        Navigator.pop(context, childResult);
                      }
                    } else {
                      Navigator.pop(context, opt);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
