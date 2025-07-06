import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../domain/entities/location_name_entity.dart';
import '../../../../../domain/usecase/location_name_usecase.dart';

class MarketplaceLocationField extends StatefulWidget {
  const MarketplaceLocationField({
    required this.onLocationSelected,
    super.key,
    this.initialText,
  });

  final ValueChanged<LocationNameEntity> onLocationSelected;
  final String? initialText;

  @override
  State<MarketplaceLocationField> createState() =>
      _MarketplaceLocationFieldState();
}

class _MarketplaceLocationFieldState extends State<MarketplaceLocationField> {
  final TextEditingController controller = TextEditingController();

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
      controller.text = widget.initialText!;
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

    final RenderBox? renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: position.dx,
        top: position.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _suggestions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'no_results'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final LocationNameEntity suggestion =
                              _suggestions[index];
                          final String mainText =
                              suggestion.structuredFormatting.mainText;
                          final MatchedSubstringEntity? match = suggestion
                              .structuredFormatting
                              .mainTextMatchedSubstrings
                              .firstOrNull;

                          int matchLength = match?.length ?? 0;
                          int matchOffset = match?.offset ?? 0;

                          // Safety guard against invalid offset/length
                          if (matchOffset + matchLength > mainText.length) {
                            matchOffset = 0;
                            matchLength = 0;
                          }

                          final String beforeMatch =
                              mainText.substring(0, matchOffset);
                          final String matchedText = mainText.substring(
                              matchOffset, matchOffset + matchLength);
                          final String afterMatch =
                              mainText.substring(matchOffset + matchLength);

                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            title: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: <InlineSpan>[
                                  TextSpan(text: beforeMatch),
                                  TextSpan(
                                    text: matchedText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: afterMatch),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              suggestion.structuredFormatting.secondaryText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorScheme.of(context).outline),
                            ),
                            onTap: () {
                              controller.text =
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
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.length < 2) {
      setState(() => _suggestions = <LocationNameEntity>[]);
      _removeOverlay();
      return;
    }

    setState(() => _isLoading = true);

    final DataState<List<LocationNameEntity>> result =
        await LocationByNameUsecase(locator()).call(query);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _suggestions = result.entity ?? <LocationNameEntity>[];
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
      child: CustomTextFormField(
        key: _fieldKey,
        focusNode: _focusNode,
        controller: controller,
        hint: 'search_location'.tr(),
        suffixIcon: _isLoading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : const Icon(Icons.search),
        onChanged: (String value) =>
            _debouncer.run(() => _fetchSuggestions(value)),
        autoFocus: false,
        readOnly: false,
        maxLines: 1,
        isExpanded: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
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
