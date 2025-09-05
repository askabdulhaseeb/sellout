import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/personal/listing/listing_form/data/sources/remote/colors_api.dart';
import '../../features/personal/listing/listing_form/domain/entities/color_options_entity.dart';
import '../../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../widgets/custom_dropdown.dart';

class ColorDropdown extends StatefulWidget {
  const ColorDropdown({
    required this.selectedColor,
    required this.onColorChanged,
    required this.validator,
    this.colorRadius,
    super.key,
    this.title = '',
    this.padding,
  });

  final String? selectedColor;
  final ValueChanged<String?> onColorChanged;
  final double? colorRadius;
  final String? Function(bool?) validator;
  final EdgeInsetsGeometry? padding;
  @override
  State<ColorDropdown> createState() => _ColorDropdownState();
  final String title;
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
    final AddListingFormProvider formPro = Provider.of(context, listen: false);

    return FutureBuilder<List<ColorOptionEntity>>(
      future: _colorFuture,
      builder: (BuildContext context,
          AsyncSnapshot<List<ColorOptionEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
          );
        }
        if (snapshot.hasError) {
          return Text('error_loading_colors'.tr());
        }

        List<ColorOptionEntity> colors = snapshot.data ?? <ColorOptionEntity>[];
        colors = colors.where((ColorOptionEntity color) {
          return color.tag.contains(formPro.selectedClothSubCategory);
        }).toList();

        if (colors.isEmpty) {
          return Text('no_colors_available'.tr());
        }

        return CustomDropdown<String>(
          title: widget.title,
          validator: widget.validator,
          hint: 'color'.tr(),
          selectedItem: widget.selectedColor,
          items: colors.map((ColorOptionEntity color) {
            return DropdownMenuItem<String>(
              value: color.value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.onColorChanged,
        );
      },
    );
  }
}
