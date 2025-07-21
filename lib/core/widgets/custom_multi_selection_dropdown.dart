import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
  OverlayEntry? _dropdownOverlay;
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    List<T> tempSelected =
        List<T>.from(widget.selectedItems); // <-- Copy selection locally

    _dropdownOverlay = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        width: widget.width ?? size.width,
        left: offset.dx,
        top: offset.dy + size.height + 4,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SizedBox(
              height: 220,
              child: StatefulBuilder(
                builder: (BuildContext context, setOverlayState) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: widget.items.map((DropdownMenuItem<T> item) {
                          final bool isSelected =
                              tempSelected.contains(item.value);
                          final ColorScheme colorScheme =
                              Theme.of(context).colorScheme;

                          return GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                tempSelected.remove(item.value);
                              } else {
                                tempSelected.add(item.value as T);
                              }
                              Future<void>.delayed(
                                  const Duration(microseconds: 100));
                              // Immediately update local UI
                              setOverlayState(() {});

                              // Notify parent
                              widget.onChanged?.call(tempSelected);
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  width: isSelected ? 3 : 1,
                                ),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              alignment: Alignment.center,
                              child: Center(
                                child: DefaultTextStyle(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  child: item.child,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_dropdownOverlay!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    if (!mounted) {
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
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
                  : colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.hint ?? 'Select',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.selectedItems.isNotEmpty
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                ),
              ),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: widget.selectedItems.isNotEmpty
                    ? colorScheme.primary
                    : colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
