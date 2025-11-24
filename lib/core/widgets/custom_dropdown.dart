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
    this.overlayAbove = false,
    this.prefix,
    this.sufixIcon,
    this.prefixIcon,
    this.initialText = '',
    this.hint,
    this.width,
    this.height,
    this.searchBy,
    this.onSearchChanged,
    this.selectedItemBuilder,
    this.selectedItemPadding,
    super.key,
  });

  final String title;
  final List<DropdownMenuItem<T>> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final String? Function(bool?) validator;
  final bool overlayAbove;
  final Widget? prefix;
  final bool? sufixIcon;
  final IconData? prefixIcon;
  final String? initialText;
  final String? hint;
  final double? width;
  final double? height;
  final String Function(DropdownMenuItem<T>)? searchBy;
  final Future<List<DropdownMenuItem<T>>> Function(String)? onSearchChanged;
  final Widget? Function(T?)? selectedItemBuilder;
  final EdgeInsetsGeometry? selectedItemPadding;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  DropdownMenuItem<T>? _findSelectedAsyncItem() {
    if (widget.selectedItem == null) return null;
    for (final DropdownMenuItem<T> item in _asyncLoadedItems) {
      if (item.value == widget.selectedItem) return item;
    }
    return null;
  }

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  String _searchText = '';
  List<DropdownMenuItem<T>> _asyncLoadedItems = <DropdownMenuItem<T>>[];
  Timer? _debounce;
  String? _lastInitialText;
  String _selectedDisplayText = '';

  @override
  void initState() {
    super.initState();
    _lastInitialText = widget.initialText;
    _setInitialText();
    _updateControllerValue();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only set initial text if it changed
    if (widget.initialText != _lastInitialText) {
      _setInitialText();
      _lastInitialText = widget.initialText;
    }
    // Always update controller value if selectedItem changes
    if (oldWidget.selectedItem != widget.selectedItem) {
      _updateControllerValue();
    }
  }

  void _setInitialText() {
    if (!mounted) return;
    if (widget.selectedItemBuilder != null) return;
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text = widget.initialText!;
      });
    }
  }

  void _updateControllerValue() {
    if (!mounted) return;
    DropdownMenuItem<T>? selectedItem;
    if (widget.onSearchChanged != null) {
      selectedItem = _findSelectedAsyncItem();
    } else {
      for (final DropdownMenuItem<T> item in widget.items) {
        if (item.value == widget.selectedItem) {
          selectedItem = item;
          break;
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (selectedItem != null && selectedItem.child is Text) {
        final String newText = (selectedItem.child as Text).data ?? '';
        _selectedDisplayText = newText;
        _controller.text = newText;
      } else {
        _selectedDisplayText = '';
        if (_controller.text.isNotEmpty) {
          _controller.text = '';
        }
      }
      _syncControllerText();
    });
  }

  void _syncControllerText() {
    if (!mounted) return;
    final bool hasCustomDisplay = widget.selectedItemBuilder != null;

    if (hasCustomDisplay) {
      if (_focusNode.hasFocus) {
        // When focused, show the selected display text (if any)
        final String next = _selectedDisplayText;
        if (_controller.text != next) {
          _controller.text = next;
        }
        if (_controller.text.isNotEmpty) {
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        }
      } else {
        // When not focused, clear the controller if no selection
        if (_controller.text.isNotEmpty && widget.selectedItem == null) {
          _controller.text = '';
        }
      }
    } else {
      // For plain dropdowns, always sync controller to selected display text
      final String next = _selectedDisplayText;
      if (_controller.text != next) {
        _controller.text = next;
      }
    }
  }

  List<DropdownMenuItem<T>> _getFilteredItems() {
    if (widget.onSearchChanged != null) {
      return _asyncLoadedItems;
    } else {
      if (_searchText.isEmpty) return widget.items;
      return widget.items
          .where((DropdownMenuItem<T> item) =>
              (_getItemText(item).toLowerCase())
                  .contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  String _getItemText(DropdownMenuItem<T> item) {
    return widget.searchBy?.call(item) ??
        (item.child is Text
            ? (item.child as Text).data ?? ''
            : item.value.toString());
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
    _syncControllerText();
  }

  void _openDropdown() {
    if (_overlayEntry != null || !mounted) return;
    setState(() => _isDropdownOpen = true);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (!mounted) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
      _searchText = '';
    });
    _focusNode.unfocus();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return OverlayEntry(builder: (_) => const SizedBox());
    }

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spaceBelow = screenHeight - offset.dy - size.height;
    final double spaceAbove = offset.dy;

    const double itemHeight = 48.0;

    return OverlayEntry(
      builder: (_) {
        final List<DropdownMenuItem<T>> items = _getFilteredItems();
        final num calculatedHeight =
            (items.length * itemHeight).clamp(0, 200.0);
        final bool showAbove = widget.overlayAbove ||
            spaceBelow < calculatedHeight && spaceAbove > spaceBelow;
        final Offset dropdownOffset = showAbove
            ? Offset(0, -calculatedHeight - 5)
            : Offset(0, size.height + 5);

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
                offset: dropdownOffset,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Material(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: calculatedHeight.toDouble()),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setStateOverlay) {
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: items.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      '${'no_data_found'.tr()}!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 0),
                                      height: 1,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ColorScheme.of(context)
                                                  .outlineVariant)),
                                    ),
                                    itemBuilder: (_, int index) {
                                      final DropdownMenuItem<T> item =
                                          items[index];
                                      return GestureDetector(
                                        child: AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 10),
                                            child: item.child,
                                          ),
                                        ),
                                        onTap: () {
                                          widget.onChanged?.call(item.value);
                                          // After selection, update controller value to show selected item
                                          setState(() {
                                            _selectedDisplayText = widget
                                                    .searchBy
                                                    ?.call(item) ??
                                                (item.child is Text
                                                    ? (item.child as Text)
                                                            .data ??
                                                        ''
                                                    : item.value.toString());
                                            _controller.text =
                                                _selectedDisplayText;
                                          });
                                          _closeDropdown();
                                        },
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
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
    final bool useCustomSelectedDisplay = widget.selectedItemBuilder != null;
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: GestureDetector(
          onTap: () {
            if (!_isDropdownOpen) _openDropdown();
          },
          child: CustomTextFormField(
            prefix: widget.prefix,
            labelText: widget.title,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            controller: _controller,
            focusNode: _focusNode,
            hint: widget.hint ?? 'select_an_item'.tr(),
            suffixIcon: useCustomSelectedDisplay || widget.sufixIcon == false
                ? null
                : Icon(_isDropdownOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded),
            onChanged: (String value) {
              setState(() => _searchText = value);
              if (_isDropdownOpen) _overlayEntry?.markNeedsBuild();
              if (widget.onSearchChanged != null) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 600), () async {
                  final List<DropdownMenuItem<T>> results =
                      await widget.onSearchChanged!(value);
                  if (!mounted) return;
                  setState(() => _asyncLoadedItems = results);
                  // After loading, update controller value to show selected item if any
                  _updateControllerValue();
                  if (_isDropdownOpen) _overlayEntry?.markNeedsBuild();
                });
              }
            },
            validator: (String? value) =>
                widget.validator(widget.selectedItem != null),
            overlayChild: useCustomSelectedDisplay
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: widget.selectedItem == null
                            ? const SizedBox.shrink()
                            : (widget.selectedItemBuilder!(
                                    widget.selectedItem) ??
                                const SizedBox.shrink()),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _isDropdownOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ],
                  )
                : null,
            overlayPadding: useCustomSelectedDisplay
                ? widget.selectedItemPadding ??
                    const EdgeInsets.only(left: 12, right: 12)
                : widget.selectedItemPadding,
          ),
        ),
      ),
    );
  }
}
