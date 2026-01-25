import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'scaffold/app_bar/app_bar_title_widget.dart';

class MultiSelectionDropdown<T> extends StatefulWidget {
  const MultiSelectionDropdown({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.isSearchable = true,
    this.padding,
    this.height,
    this.width,
    this.hint,
    super.key,
  });

  final String title;
  final void Function(List<T>)? onChanged;
  final List<T> selectedItems;
  final List<DropdownMenuItem<T>> items;
  final EdgeInsetsGeometry? padding;
  final String? hint;
  final double? height;
  final double? width;
  final bool isSearchable;

  @override
  State<MultiSelectionDropdown<T>> createState() => _MultiWidgetState<T>();
}

class _MultiWidgetState<T> extends State<MultiSelectionDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final bool _isDropdownOpen = false;
  void _toggleDropdown() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        List<T> tempSelected = List<T>.from(widget.selectedItems);
        return StatefulBuilder(
          builder: (BuildContext context,StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                backgroundBlendMode: BlendMode.color,
              ),
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const CloseButton(),
                      AppBarTitle(titleKey: widget.hint ?? ''),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempSelected.clear();
                          });
                          widget.onChanged?.call(tempSelected);
                        },
                        child: Text(
                          'reset'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: widget.items.map((DropdownMenuItem<T> item) {
                          final bool isSelected = tempSelected.contains(
                            item.value,
                          );
                          return ChoiceChip(
                            showCheckmark: false,
                            side: BorderSide(
                              width: isSelected ? 2 : 1,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.outline,
                            ),
                            label: item.child,
                            selected: isSelected,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected) {
                                  tempSelected.add(item.value as T);
                                } else {
                                  tempSelected.remove(item.value);
                                }
                              });
                              widget.onChanged?.call(tempSelected);
                            },
                            selectedColor: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.2),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 48,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.selectedItems.isNotEmpty
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.selectedItems.isNotEmpty
                  ? Theme.of(context).primaryColor
                  : colorScheme.outline,
              width: widget.selectedItems.isNotEmpty ? 2 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.hint ?? 'select'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.selectedItems.isNotEmpty
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
              ),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: widget.selectedItems.isNotEmpty
                    ? colorScheme.primary
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
