import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/widgets/custom_expandable_tile.dart';
import '../../../../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../providers/add_listing_form_provider.dart';
import 'data/package_presets.dart';

class PackageDetailsCard extends StatefulWidget {
  const PackageDetailsCard({super.key});

  @override
  State<PackageDetailsCard> createState() => _PackageDetailsCardState();
}

class _PackageDetailsCardState extends State<PackageDetailsCard> {
  late final VoidCallback _onDimsChanged;
  late final AddListingFormProvider _formPro;
  String? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    _formPro = Provider.of<AddListingFormProvider>(context, listen: false);
    _onDimsChanged = () => setState(() {});
    _formPro.packageLength.addListener(_onDimsChanged);
    _formPro.packageWidth.addListener(_onDimsChanged);
    _formPro.packageHeight.addListener(_onDimsChanged);
  }

  @override
  void dispose() {
    _formPro.packageLength.removeListener(_onDimsChanged);
    _formPro.packageWidth.removeListener(_onDimsChanged);
    _formPro.packageHeight.removeListener(_onDimsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro = _formPro;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // Build items for CustomExpandableTileGroup
    final List<ExpandableTileItem> items = <ExpandableTileItem>[
      ...packagePresets
          .asMap()
          .entries
          .where((MapEntry<int, Map<String, dynamic>> entry) {
            return entry.value['options'] != null;
          })
          .map((MapEntry<int, Map<String, dynamic>> entry) {
            final Map<String, dynamic> preset = entry.value;
            final String tileId =
                preset['id'] as String? ?? 'preset-${entry.key}';
            final List<dynamic> options =
                preset['options'] as List<dynamic>? ?? <dynamic>[];
            final bool tileHasSelectedOption = options.asMap().entries.any((
              MapEntry<int, dynamic> optEntry,
            ) {
              final String optionId = '$tileId-${optEntry.key}';
              return optionId == _selectedOptionId;
            });
            return ExpandableTileItem(
              id: tileId,
              title: tr(preset['titleKey'] as String? ?? ''),
              subtitle: preset['subtitle'] as String?,
              icon: _iconFromString(preset['icon'] as String? ?? ''),
              initiallyExpanded: entry.key == 0,
              isSelected: tileHasSelectedOption,
              body: (BuildContext context) {
                return _buildPresetOptions(
                  context,
                  preset,
                  formPro,
                  scheme,
                  tileId,
                );
              },
            );
          }),
      ExpandableTileItem(
        id: 'custom',
        title: tr('custom_parcel'),
        subtitle: null,
        icon: Icons.edit_note,
        body: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomTextFormField(
                controller: formPro.packageWeight,
                keyboardType: TextInputType.number,
                labelText: tr('weight_kg'),
                validator: (String? value) {
                  final String input = (value ?? '').trim();
                  if (input.isEmpty) return 'required'.tr();
                  final double? v = double.tryParse(input.replaceAll(',', '.'));
                  if (v == null || v <= 0) return 'invalid_value'.tr();
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.vSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: CustomTextFormField(
                      controller: formPro.packageLength,
                      keyboardType: TextInputType.number,
                      labelText: '${'length'.tr()} (cm)',
                      validator: (String? value) {
                        final String input = (value ?? '').trim();
                        if (input.isEmpty) return 'required'.tr();
                        final double? v = double.tryParse(
                          input.replaceAll(',', '.'),
                        );
                        if (v == null || v <= 0) return 'invalid_value'.tr();
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.hXs),
                  Flexible(
                    flex: 1,
                    child: CustomTextFormField(
                      controller: formPro.packageWidth,
                      keyboardType: TextInputType.number,
                      labelText: '${'width'.tr()} (cm)',
                      validator: (String? value) {
                        final String input = (value ?? '').trim();
                        if (input.isEmpty) return 'required'.tr();
                        final double? v = double.tryParse(
                          input.replaceAll(',', '.'),
                        );
                        if (v == null || v <= 0) return 'invalid_value'.tr();
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.hXs),
                  Flexible(
                    flex: 1,
                    child: CustomTextFormField(
                      controller: formPro.packageHeight,
                      keyboardType: TextInputType.number,
                      labelText: '${'height'.tr()} (cm)',
                      validator: (String? value) {
                        final String input = (value ?? '').trim();
                        if (input.isEmpty) return 'required'.tr();
                        final double? v = double.tryParse(
                          input.replaceAll(',', '.'),
                        );
                        if (v == null || v <= 0) return 'invalid_value'.tr();
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('parcel_size'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          'size_selection_notice'.tr(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant.withAlpha(180),
          ),
        ),
        const Divider(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: scheme.outline),
          ),
          child: CustomExpandableTileGroup(items: items),
        ),
        // Print button removed
      ],
    );
  }

  Widget _buildPresetOptions(
    BuildContext context,
    Map<String, dynamic> preset,
    AddListingFormProvider formPro,
    ColorScheme scheme,
    String tileId,
  ) {
    final List<dynamic> options =
        preset['options'] as List<dynamic>? ?? <dynamic>[];

    void updateFields(Map<String, dynamic> option) {
      final List<dynamic>? dims = option['dims'] as List<dynamic>?;
      if (dims?.length == 3) {
        formPro.packageLength.text = '${dims![0]}';
        formPro.packageWidth.text = '${dims[1]}';
        formPro.packageHeight.text = '${dims[2]}';
      }
      final dynamic w = option['weight'];
      double? weight;
      if (w != null) {
        if (w is num) {
          weight = w.toDouble();
        } else if (w is String) {
          weight = double.tryParse(w);
        }
      }
      if (weight != null && weight > 0) {
        formPro.packageWeight.text = weight.toString();
      } else {
        formPro.packageWeight.text = ''; // Default to 2 if missing/invalid
      }
    }

    return Column(
      children: options.asMap().entries.map((MapEntry<int, dynamic> optEntry) {
        final int optIndex = optEntry.key;
        final Map<String, dynamic> option = Map<String, dynamic>.from(
          optEntry.value as Map,
        );
        final String optionId = '$tileId-$optIndex';
        final bool isSelected = _selectedOptionId == optionId;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                _selectedOptionId = optionId;
                updateFields(option);
              });
            },
            leading: Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? scheme.primary : scheme.outlineVariant,
            ),
            title: Text(tr(option['labelKey'] as String? ?? '')),
            subtitle: Text(tr(option['noteKey'] as String? ?? '')),
          ),
        );
      }).toList(),
    );
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'mail':
        return Icons.mail;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.help_outline;
    }
  }
}
