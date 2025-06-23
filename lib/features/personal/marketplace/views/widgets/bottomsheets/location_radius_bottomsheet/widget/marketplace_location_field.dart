import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../domain/entities/location_name_entity.dart';
import '../../../../../domain/usecase/location_name_usecase.dart';

class MarketplaceLocationField extends StatefulWidget {
  const MarketplaceLocationField({
    required this.controller,
    required this.onLocationSelected,
    super.key,
    this.initialText,
  });

  final TextEditingController controller;
  final ValueChanged<LocationNameEntity> onLocationSelected;
  final String? initialText;

  @override
  State<MarketplaceLocationField> createState() =>
      _MarketplaceLocationFieldState();
}

class _MarketplaceLocationFieldState extends State<MarketplaceLocationField> {
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();

  List<LocationNameEntity> _suggestions = <LocationNameEntity>[];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      widget.controller.text = widget.initialText!;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox box =
        _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 4),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _suggestions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('no_results'.tr()),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _suggestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            final suggestion = _suggestions[index];
                            return ListTile(
                              title: Text(
                                  suggestion.structuredFormatting.mainText),
                              subtitle: suggestion.structuredFormatting
                                      .secondaryText.isNotEmpty
                                  ? Text(suggestion
                                      .structuredFormatting.secondaryText)
                                  : null,
                              onTap: () {
                                widget.controller.text =
                                    suggestion.structuredFormatting.mainText;
                                widget.onLocationSelected(suggestion);
                                _focusNode.unfocus();
                                _removeOverlay();
                              },
                            );
                          },
                        ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
      });
      _removeOverlay();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final DataState<List<LocationNameEntity>> result =
        await LocationByNameUsecase(locator()).call(query);

    setState(() {
      _isLoading = false;
      _suggestions = result.entity ?? [];
    });

    if (_focusNode.hasFocus && (_suggestions.isNotEmpty || _isLoading)) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        key: _fieldKey,
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          border: const OutlineInputBorder(),
          hintText: 'search_location'.tr(),
          suffixIcon: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
        onChanged: (value) => _debouncer.run(() => _fetchSuggestions(value)),
      ),
    );
  }
}

class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
