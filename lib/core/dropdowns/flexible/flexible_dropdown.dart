import 'package:flutter/material.dart';
import '../../widgets/custom_textformfield.dart';
import 'dropdown_controller.dart';
import 'dropdown_overlay.dart';
import 'package:easy_localization/easy_localization.dart';

class FlexibleDropdown<T> extends StatefulWidget {
  const FlexibleDropdown({
    required this.onChanged,
    required this.tileBuilder,
    required this.searchBy,
    required this.items,
    this.asyncLoader,
    this.selectedItem,
    this.hint,
    this.label,
    this.validator,
    this.clearable = true,
    this.dropdownMaxHeight = 350,
    this.enabled = true,
    super.key,
  });

  final Future<List<T>> Function(String search)? asyncLoader;
  final List<T>? items;
  final T? selectedItem;
  final String? hint;
  final String? label;
  final bool clearable;
  final double dropdownMaxHeight;
  final bool enabled;
  final Widget Function(BuildContext, T, bool isSelected) tileBuilder;
  final String Function(T) searchBy;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  @override
  State<FlexibleDropdown<T>> createState() => _FlexibleDropdownState<T>();
}

class _FlexibleDropdownState<T> extends State<FlexibleDropdown<T>> {
  late final DropdownController<T> _controller;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = DropdownController<T>();
    _controller.selected = widget.selectedItem;
    if (widget.asyncLoader == null && widget.items != null) {
      _controller.items = widget.items!;
    }
    _controller.focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant FlexibleDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _controller.selected = widget.selectedItem;
    }
    if (widget.items != oldWidget.items && widget.asyncLoader == null) {
      _controller.items = widget.items ?? <T>[];
    }
  }

  void _handleFocus() {
    if (_controller.focusNode.hasFocus) {
      _openDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _openDropdown() async {
    if (_overlayEntry != null) return;
    if (widget.asyncLoader != null) {
      setState(() => _controller.loading = true);
      _controller.items = await widget.asyncLoader!(_controller.search);
      setState(() => _controller.loading = false);
    }
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_controller.loading) {
      setState(() {
        _controller.loading = false;
      });
    }
  }

  OverlayEntry _buildOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double availableHeightBelow =
        screenHeight - offset.dy - size.height - keyboardHeight;
    final double availableHeightAbove = offset.dy;
    final bool showAbove =
        availableHeightBelow < widget.dropdownMaxHeight &&
        availableHeightAbove > availableHeightBelow;
    final double maxHeight = showAbove
        ? availableHeightAbove - 16
        : availableHeightBelow - 16;

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        width: size.width,
        top: showAbove ? (offset.dy - maxHeight) : (offset.dy + size.height),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 0),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                color: ColorScheme.of(context).onSurface.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    controller: _controller.searchController,
                    hint: 'search'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: ColorScheme.of(
                          context,
                        ).onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                    autoFocus: true,
                    onChanged: (String val) async {
                      setState(() => _controller.search = val);
                      if (widget.asyncLoader != null) {
                        setState(() => _controller.loading = true);
                        _controller.items = await widget.asyncLoader!(val);
                        setState(() => _controller.loading = false);
                      } else {
                        setState(() {
                          _controller.items = (widget.items ?? <T>[])
                              .where(
                                (item) => widget
                                    .searchBy(item)
                                    .toLowerCase()
                                    .contains(val.toLowerCase()),
                              )
                              .toList();
                        });
                      }
                    },
                  ),
                ),
                Flexible(
                  child: DropdownOverlay<T>(
                    items: _controller.items,
                    selectedItem: _controller.selected,
                    maxHeight: widget.dropdownMaxHeight < maxHeight
                        ? widget.dropdownMaxHeight
                        : maxHeight,
                    tileBuilder: widget.tileBuilder,
                    onItemSelected: (item) {
                      setState(() {
                        _controller.selected = item;
                      });
                      widget.onChanged(item);
                      _removeDropdown();
                      FocusScope.of(context).unfocus();
                    },
                    loading: false,
                    noResultsText: 'no_results_found'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    _controller.focusNode.removeListener(_handleFocus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled
            ? () => _controller.focusNode.requestFocus()
            : null,
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.label,
            border: const OutlineInputBorder(),
            suffixIcon: widget.clearable && _controller.selected != null
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    tooltip: 'Clear',
                    onPressed: () {
                      setState(() {
                        _controller.selected = null;
                      });
                      widget.onChanged(null);
                    },
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
          isEmpty: _controller.selected == null,
          child: _controller.selected == null
              ? Text(
                  widget.hint ?? '',
                  style: TextStyle(color: Theme.of(context).hintColor),
                )
              : widget.tileBuilder(context, _controller.selected as T, true),
        ),
      ),
    );
  }
}
