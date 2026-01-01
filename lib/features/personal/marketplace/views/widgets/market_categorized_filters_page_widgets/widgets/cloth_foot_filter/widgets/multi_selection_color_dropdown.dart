import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_multi_selection_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/remote/colors_api.dart';
import '../../../../../../../listing/listing_form/domain/entities/color_options_entity.dart';
import '../../../../../providers/marketplace_provider.dart';

class MultiColorDropdown extends StatefulWidget {
  const MultiColorDropdown({
    required this.selectedColors,
    required this.onColorsChanged,
    this.colorRadius,
    super.key,
    this.title = '',
    this.padding,
  });

  final List<String> selectedColors;
  final ValueChanged<List<String>> onColorsChanged;
  final double? colorRadius;
  final EdgeInsetsGeometry? padding;
  final String title;

  @override
  State<MultiColorDropdown> createState() => _MultiColorDropdownState();
}

class _MultiColorDropdownState extends State<MultiColorDropdown> {
  late Future<List<ColorOptionEntity>> _colorFuture;

  @override
  void initState() {
    super.initState();
    _colorFuture = ColorOptionsApi().getColors();
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Extract base color name from label by removing shade prefixes like "Light", "Dark", etc.
  String _getBaseColorName(String label) {
    final List<String> shadePrefixes = <String>[
      'light ',
      'dark ',
      'pale ',
      'bright ',
      'deep ',
      'soft ',
      'vivid ',
    ];
    String lowerLabel = label.toLowerCase();
    for (final String prefix in shadePrefixes) {
      if (lowerLabel.startsWith(prefix)) {
        lowerLabel = lowerLabel.substring(prefix.length);
        break;
      }
    }
    return _capitalizeFirst(lowerLabel);
  }

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider formPro = Provider.of(context, listen: false);

    return FutureBuilder<List<ColorOptionEntity>>(
      future: _colorFuture,
      builder: (BuildContext context,
          AsyncSnapshot<List<ColorOptionEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            child: Center(child: SizedBox.shrink()),
          );
        }
        if (snapshot.hasError) {
          return Text('error_loading_colors'.tr());
        }

        List<ColorOptionEntity> colors = snapshot.data ?? <ColorOptionEntity>[];
        colors = colors.where((ColorOptionEntity color) {
          return color.tag.contains(formPro.cLothFootCategory);
        }).toList();

        if (colors.isEmpty) {
          return Text('no_colors_available'.tr());
        }

        // Group colors by base color name and collect all shades
        final Map<String, List<ColorOptionEntity>> colorGroups =
            <String, List<ColorOptionEntity>>{};
        for (final ColorOptionEntity color in colors) {
          final String baseColor = _getBaseColorName(color.label).toLowerCase();
          colorGroups.putIfAbsent(baseColor, () => <ColorOptionEntity>[]);
          colorGroups[baseColor]!.add(color);
        }

        return MultiSelectionDropdown<String>(
          title: widget.title,
          hint: 'color'.tr(),
          selectedItems: widget.selectedColors,
          items: colorGroups.entries.map((MapEntry<String, List<ColorOptionEntity>> entry) {
            final String baseColorName = entry.key;
            final List<ColorOptionEntity> shades = entry.value;

            // Get colors for gradient (or single color)
            final List<Color> shadeColors = shades.map((ColorOptionEntity shade) {
              return Color(int.parse('0xFF${shade.value.replaceAll('#', '')}'));
            }).toList();

            return DropdownMenuItem<String>(
              value: baseColorName,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: shadeColors.length > 1
                          ? SweepGradient(colors: shadeColors)
                          : null,
                      color: shadeColors.length == 1 ? shadeColors.first : null,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _capitalizeFirst(baseColorName),
                    style: TextTheme.of(context)
                        .labelSmall
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.onColorsChanged,
        );
      },
    );
  }
}
