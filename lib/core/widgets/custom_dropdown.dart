import 'package:flutter/material.dart';

import 'custom_textformfield.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.validator,
    super.key,
    this.hint,
    this.width,
    this.height,
    this.searchBy,
  });

  final String title;
  final List<DropdownMenuItem<T>> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final String? Function(bool?) validator;
  final String? hint;
  final double? width;
  final double? height;
  final String Function(DropdownMenuItem<T>)? searchBy;
  @override
  CustomDropdownState<T> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;
  String _searchText = '';

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
    final DropdownMenuItem<T> selectedItem = widget.items.firstWhere(
      (DropdownMenuItem<T> item) => item.value == widget.selectedItem,
      orElse: () => DropdownMenuItem<T>(
        value: null,
        child: const SizedBox(),
      ),
    );

    if (selectedItem.value != null) {
      final String selectedText = widget.searchBy != null
          ? widget.searchBy!(selectedItem)
          : selectedItem.child is Text
              ? (selectedItem.child as Text).data ?? ''
              : selectedItem.value.toString();

      _controller.text = selectedText;
    } else if (_controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  String _getItemText(DropdownMenuItem<T> item) {
    return widget.searchBy != null
        ? widget.searchBy!(item)
        : item.child is Text
            ? (item.child as Text).data ?? ''
            : item.value.toString();
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

    setState(() {
      _isDropdownOpen = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
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
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200.0,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: _getFilteredItems().map((DropdownMenuItem<T> item) {
                  return ListTile(
                    title: item.child,
                    onTap: () {
                      widget.onChanged?.call(item.value);
                      _closeDropdown();
                      _focusNode.unfocus();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<T>> _getFilteredItems() {
    if (_searchText.isEmpty) {
      return widget.items;
    }

    return widget.items.where((DropdownMenuItem<T> item) {
      final String itemText = _getItemText(item);
      return itemText.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: CustomTextFormField(
            controller: _controller,
            focusNode: _focusNode,
            hint: widget.hint ?? 'Select an item',
            suffixIcon: Icon(
              _isDropdownOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
            onChanged: (String value) {
              setState(() {
                _searchText = value;
              });
              // Update the overlay if it's open
              if (_isDropdownOpen && _overlayEntry != null) {
                _overlayEntry!.markNeedsBuild();
              }
              if (value.isEmpty && !_isDropdownOpen) {
                _openDropdown();
              }
            },
          ),
        ),
      ],
    );
  }
}
