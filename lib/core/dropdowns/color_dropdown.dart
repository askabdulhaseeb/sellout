import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/personal/listing/listing_form/data/sources/remote/colors_api.dart';
import '../../features/personal/listing/listing_form/domain/entities/color_options_entity.dart';
import 'flexible/flexible_dropdown.dart';

class ColorDropdown extends StatefulWidget {
  const ColorDropdown({
    required this.onColorChanged,
    required this.validator,
    this.selectedColor,
    this.colorRadius,
    this.title = '',
    this.overlayAbove = false,
    super.key,
  });

  final ColorOptionEntity? selectedColor;
  final ValueChanged<ColorOptionEntity?> onColorChanged;
  final String? Function(bool?) validator;
  final double? colorRadius;
  final String title;
  final bool overlayAbove;

  @override
  State<ColorDropdown> createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  late Future<List<ColorOptionEntity>> _colorFuture;

  @override
  void initState() {
    super.initState();
    _colorFuture = ColorOptionsApi().getColors();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ColorOptionEntity>>(
      future: _colorFuture,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<ColorOptionEntity>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              );
            }
            if (snapshot.hasError) {
              return Text('error_loading_colors'.tr());
            }

            final List<ColorOptionEntity> colors =
                snapshot.data ?? <ColorOptionEntity>[];

            if (colors.isEmpty) {
              return Text('no_colors_available'.tr());
            }

            return FlexibleDropdown<ColorOptionEntity>(
              items: colors,
              selectedItem: widget.selectedColor,
              onChanged: widget.onColorChanged,
              label: widget.title.isNotEmpty ? widget.title : null,
              hint: 'color'.tr(),
              validator: (ColorOptionEntity? val) =>
                  widget.validator(val != null),
              tileBuilder:
                  (
                    BuildContext context,
                    ColorOptionEntity color,
                    bool isSelected,
                  ) => Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: widget.colorRadius ?? 6,
                        backgroundColor: Color(
                          int.parse('0xFF${color.value.replaceAll('#', '')}'),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          color.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
              searchBy: (ColorOptionEntity color) => color.label,
            );
          },
    );
  }
}
