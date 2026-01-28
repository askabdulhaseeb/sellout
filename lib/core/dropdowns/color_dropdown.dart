import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/personal/listing/listing_form/data/sources/remote/colors_api.dart';
import '../../features/personal/listing/listing_form/domain/entities/color_options_entity.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../widgets/inputs/custom_textformfield.dart';


class ColorDropdown extends StatefulWidget {
  const ColorDropdown({
    required this.onColorChanged,
    required this.validator,
    this.selectedColor,
    this.colorRadius,
    this.title = '',
    this.direction = VerticalDirection.down,
    super.key,
  });

  final ColorOptionEntity? selectedColor;
  final ValueChanged<ColorOptionEntity?> onColorChanged;
  final String? Function(bool?) validator;
  final double? colorRadius;
  final String? title;
  final VerticalDirection direction;

  @override
  State<ColorDropdown> createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  TextEditingController? _controller;

  @override
  void didUpdateWidget(ColorDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep controller in sync with selectedColor
    if (_controller != null &&
        widget.selectedColor?.label != oldWidget.selectedColor?.label) {
      _controller!.text = widget.selectedColor?.label ?? '';
    }
  }

  late Future<List<ColorOptionEntity>> _colorFuture;

  @override
  void initState() {
    super.initState();
    _colorFuture = ColorOptionsApi().getColors();
  }

  // No need to dispose controller, handled by TypeAheadField

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ColorOptionEntity>>(
      future: _colorFuture,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<ColorOptionEntity>> snapshot,
          ) {
            final List<ColorOptionEntity> colors =
                snapshot.data ?? <ColorOptionEntity>[];
            return TypeAheadField<ColorOptionEntity>(
              direction: widget.direction,
              suggestionsCallback: (String pattern) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return <ColorOptionEntity>[];
                }
                if (snapshot.hasError || colors.isEmpty) {
                  return <ColorOptionEntity>[];
                }
                return colors
                    .where(
                      (ColorOptionEntity color) => color.label
                          .toLowerCase()
                          .contains(pattern.toLowerCase()),
                    )
                    .toList();
              },
              builder:
                  (
                    BuildContext context,
                    TextEditingController controller,
                    FocusNode focusNode,
                  ) {
                    _controller = controller;
                    // Always show selected color in field
                    if (widget.selectedColor != null &&
                        controller.text != widget.selectedColor!.label) {
                      controller.text = widget.selectedColor!.label;
                    }
                    return CustomTextFormField(
                      hint: widget.title ?? 'location'.tr(),
                      labelText: widget.title ?? '',
                      controller: controller,

                      focusNode: focusNode,
                      onTap: () {
                        focusNode.requestFocus();
                        controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: controller.text.length,
                        );
                      },
                      onChanged: (String value) {},
                    );
                  },
              itemSeparatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Theme.of(context).dividerColor,
                  endIndent: 4,
                  indent: 4,
                );
              },
              itemBuilder: (BuildContext context, ColorOptionEntity color) {
                return Container(
                  margin: const EdgeInsets.all(6),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: widget.colorRadius ?? 6,
                        backgroundColor: Color(
                          int.parse('0xFF${color.value.replaceAll('#', '')}'),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          color.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (ColorOptionEntity? color) {
                if (_controller != null) {
                  _controller!.text = color?.label ?? '';
                }
                widget.onColorChanged(color);
              },
              emptyBuilder: (BuildContext context) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text('no_data_found'.tr());
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('no_data_found'.tr()),
                );
              },
            );
          },
    );
  }
}
