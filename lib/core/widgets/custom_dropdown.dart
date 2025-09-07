import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'custom_textformfield.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.validator,
    this.sufixIcon,
    this.prefixIcon,
    this.initialText = '',
    this.hint,
    this.width,
    this.height,
    this.searchBy,
    this.onSearchChanged,
    this.isDynamic = false,
    super.key,
  });

  final String title;
  final List<DropdownMenuItem<T>> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final String? Function(bool?) validator;
  final bool? sufixIcon;
  final IconData? prefixIcon;
  final String? initialText;
  final String? hint;
  final double? width;
  final double? height;
  final String Function(DropdownMenuItem<T>)? searchBy;

  /// async search callback (optional)
  final Future<List<DropdownMenuItem<T>>> Function(String)? onSearchChanged;

  /// if true → use async search, otherwise → use static items
  final bool isDynamic;
  @override
  CustomDropdownState<T> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  String _searchText = '';
  List<DropdownMenuItem<T>> _dynamicItems = <DropdownMenuItem<T>>[];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _updateControllerValue();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem ||
        oldWidget.items != widget.items) {
      _updateControllerValue();
    }
  }

  void _updateControllerValue() {
    if (widget.isDynamic) {
      // 🔹 For dynamic suggestions → just use initialText
      if (widget.initialText != null && widget.initialText!.isNotEmpty) {
        _controller.text = widget.initialText!;
      } else {
        _controller.clear();
      }
      return;
    }

    // 🔹 For static items
    final DropdownMenuItem<T> selectedItem = widget.items.firstWhere(
      (DropdownMenuItem<T> item) => item.value == widget.selectedItem,
      orElse: () => DropdownMenuItem<T>(
        value: null,
        child: const SizedBox(),
      ),
    );

    if (selectedItem.value != null) {
      final String text = widget.searchBy?.call(selectedItem) ??
          (selectedItem.child is Text
              ? (selectedItem.child as Text).data ?? ''
              : selectedItem.value.toString());

      _controller.text = text;
    } else {
      _controller.clear();
    }
  }

  String _getItemText(DropdownMenuItem<T> item) {
    return widget.searchBy?.call(item) ??
        (item.child is Text
            ? (item.child as Text).data ?? ''
            : item.value.toString());
  }

  List<DropdownMenuItem<T>> _getFilteredItems() {
    if (widget.isDynamic) {
      return _dynamicItems;
    }

    if (_searchText.isEmpty) return widget.items;

    return widget.items.where((DropdownMenuItem<T> item) {
      final String text = _getItemText(item);
      return text.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _openDropdown();
    } else {
      _closeDropdown();
      _updateControllerValue();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null) return;

    setState(() => _isDropdownOpen = true);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      _isDropdownOpen = false;
      _searchText = '';
    });

    _updateControllerValue();
    _focusNode.unfocus();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    return OverlayEntry(
      builder: (BuildContext context) {
        final List<DropdownMenuItem<T>> filteredItems = _getFilteredItems();
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.translucent,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final DropdownMenuItem<T> item = filteredItems[index];
                        return ListTile(
                          minVerticalPadding: 2,
                          title: item.child,
                          onTap: () {
                            widget.onChanged?.call(item.value);
                            _closeDropdown();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              if (!_isDropdownOpen) _openDropdown();
            },
            child: CustomTextFormField(
              prefixIcon:
                  widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
              controller: _controller,
              focusNode: _focusNode,
              hint: widget.hint ?? 'select_an_item'.tr(),
              suffixIcon: widget.sufixIcon == false
                  ? null
                  : Icon(
                      _isDropdownOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
              onChanged: (String value) {
                setState(() => _searchText = value);
                // 🔹 Debounce logic
                if (widget.isDynamic && widget.onSearchChanged != null) {
                  _debounce?.cancel();
                  _debounce =
                      Timer(const Duration(milliseconds: 600), () async {
                    final List<DropdownMenuItem<T>> results =
                        await widget.onSearchChanged!(value);
                    setState(() {
                      _dynamicItems = results;
                    });
                    if (_isDropdownOpen) {
                      _overlayEntry?.markNeedsBuild();
                    }
                  });
                } else {
                  if (_isDropdownOpen) {
                    _overlayEntry?.markNeedsBuild();
                  }
                }
                if (value.isEmpty && !_isDropdownOpen) {
                  _openDropdown();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
