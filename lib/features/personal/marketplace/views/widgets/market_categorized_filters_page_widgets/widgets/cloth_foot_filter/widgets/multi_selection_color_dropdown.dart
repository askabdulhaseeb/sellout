import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_multi_selection_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/remote/colors_api.dart';
import '../../../../../../../listing/listing_form/domain/entities/color_options_entity.dart';
import '../../../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';

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
            child: Center(child: SizedBox.shrink()),
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

        return MultiSelectionDropdown<String>(
          title: widget.title,
          hint: 'color'.tr(),
          selectedItems: widget.selectedColors,
          items: colors.map((ColorOptionEntity color) {
            return DropdownMenuItem<String>(
              value: color.value,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.spaceEvenly,
                spacing: 2,
                children: <Widget>[
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(
                      int.parse('0xFF${color.value.replaceAll('#', '')}'),
                    ),
                  ),
                  Text(
                    color.label,
                    style: TextTheme.of(context)
                        .labelSmall
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  )
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
