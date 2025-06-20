import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../data/sources/local/local_dropdown_listings.dart';
import '../../domain/entities/dropdown_listings_entity.dart';

class CustomDynamicDropdown extends StatefulWidget {
  const CustomDynamicDropdown({
    required this.categoryKey,
    required this.selectedValue,
    required this.onChanged,
    this.title = '',
    this.hint = '',
    super.key,
  });

  final String categoryKey;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String title;
  final String hint;

  @override
  State<CustomDynamicDropdown> createState() => _CustomDynamicDropdownState();
}

class _CustomDynamicDropdownState extends State<CustomDynamicDropdown> {
  List<DropdownOptionEntity> options = <DropdownOptionEntity>[];
  bool isLoading = true;
  String? displayLabel;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() => isLoading = true);

    try {
      final Box<DropdownCategoryEntity> box =
          Hive.box(LocalDropDownListings.boxTitle);
      final DropdownCategoryEntity? category = box.get(widget.categoryKey);

      if (category != null) {
        options = category.options;
        _updateDisplayLabel(widget.selectedValue, category.options);
      }
    } catch (e) {
      debugPrint('Dropdown load error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _updateDisplayLabel(String? value, List<DropdownOptionEntity> opts) {
    for (final DropdownOptionEntity opt in opts) {
      if (opt.value == value) {
        setState(() => displayLabel = opt.label);
        return;
      }
      if (opt.children.isNotEmpty) {
        _updateDisplayLabel(value, opt.children);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title.isNotEmpty)
            Text(
              widget.title.tr(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          if (widget.title.isNotEmpty) const SizedBox(height: 2),
          GestureDetector(
            onTap: _showPicker,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: widget.hint.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      displayLabel ?? widget.hint.tr(),
                      style: TextTheme.of(context).bodyMedium,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPicker() async {
    final DropdownOptionEntity? result =
        await _showOptionsBottomSheet(widget.title, options, null);
    if (result != null) {
      setState(() {
        displayLabel = result.label;
      });
      widget.onChanged(result.value);
    }
  }

  Future<DropdownOptionEntity?> _showOptionsBottomSheet(
    String title,
    List<DropdownOptionEntity> opts,
    String? parentValue,
  ) {
    return showModalBottomSheet<DropdownOptionEntity>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7),
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
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: opts.map((DropdownOptionEntity opt) {
                    return ListTile(
                      title: Text(opt.label),
                      trailing: opt.children.isNotEmpty
                          ? const Icon(Icons.chevron_right)
                          : null,
                      onTap: () async {
                        if (opt.children.isNotEmpty) {
                          final DropdownOptionEntity? childResult =
                              await _showOptionsBottomSheet(
                            opt.label,
                            opt.children,
                            opt.value,
                          );
                          if (childResult != null) {
                            // Return the final child
                            Navigator.pop(context, childResult);
                          }
                        } else {
                          Navigator.pop(context, opt);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
