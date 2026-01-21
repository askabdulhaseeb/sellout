import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/widgets/custom_expandable_tile.dart';
import '../../../../../providers/add_listing_form_provider.dart';
import 'ui/weight_section.dart';
import 'logic/weight_unit_sync.dart';
import 'data/package_presets.dart';
import 'ui/inline_size_field.dart';

class PackageDetailsCard extends StatefulWidget {
  const PackageDetailsCard({super.key});

  @override
  State<PackageDetailsCard> createState() => _PackageDetailsCardState();
}

class _PackageDetailsCardState extends State<PackageDetailsCard> {
  bool _isKg = true;
  late final VoidCallback _onDimsChanged;
  late final AddListingFormProvider _formPro;
  late final WeightUnitSync _weightSync;
  String? _expandedTileId;

  @override
  void initState() {
    super.initState();
    _formPro = Provider.of<AddListingFormProvider>(context, listen: false);
    _onDimsChanged = () => setState(() {});
    _weightSync = WeightUnitSync(storageController: _formPro.packageWeight);
    _weightSync.init();
    _formPro.packageLength.addListener(_onDimsChanged);
    _formPro.packageWidth.addListener(_onDimsChanged);
    _formPro.packageHeight.addListener(_onDimsChanged);
    // keep _isKg in sync with helper
    _isKg = _weightSync.isKg;
  }

  @override
  void dispose() {
    _formPro.packageLength.removeListener(_onDimsChanged);
    _formPro.packageWidth.removeListener(_onDimsChanged);
    _formPro.packageHeight.removeListener(_onDimsChanged);
    _weightSync.dispose();
    super.dispose();
  }

  void _toggleUnit(AddListingFormProvider formPro, bool toKg) {
    if (_isKg == toKg) return;
    _weightSync.toggleUnit(toKg);
    setState(() => _isKg = _weightSync.isKg);
  }

  // groupBySize now imported from logic/group_by_size.dart

  String? selectedDimsText() {
    final AddListingFormProvider formPro = _formPro;
    if (formPro.packageLength.text.isEmpty ||
        formPro.packageWidth.text.isEmpty ||
        formPro.packageHeight.text.isEmpty) {
      return null;
    }
    return '${formPro.packageLength.text} × ${formPro.packageWidth.text} × ${formPro.packageHeight.text} cm';
  }

  String? matchedPresetLabel() {
    final AddListingFormProvider formPro = _formPro;
    if (formPro.packageLength.text.isEmpty ||
        formPro.packageWidth.text.isEmpty ||
        formPro.packageHeight.text.isEmpty) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro = _formPro;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // Use packagePresets from data/package_presets.dart and localize keys inline
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
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            spacing: AppSpacing.vSm,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ...packagePresets.asMap().entries.map((
                    MapEntry<int, Map<String, dynamic>> entry,
                  ) {
                    final int index = entry.key;
                    final Map<String, dynamic> preset = entry.value;
                    final String tileId = 'preset-$index';
                    return CustomExpandableTile(
                      title: tr(preset['titleKey'] as String),
                      subtitle: preset['subtitle'] as String,
                      icon: _iconFromString(preset['icon'] as String),
                      options: (preset['options'] as List<dynamic>).map((opt) {
                        final option = Map<String, dynamic>.from(opt as Map);
                        return {
                          ...option,
                          'label': tr(option['labelKey'] as String),
                          'note': tr(option['noteKey'] as String),
                        };
                      }).toList(),
                      isExpanded: _expandedTileId == tileId,
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _expandedTileId = expanded ? tileId : null;
                        });
                      },
                      onOptionSelected: (Map<String, dynamic> option) {
                        final List<dynamic> dims =
                            option['dims'] as List<dynamic>;
                        formPro.packageLength.text = dims[0].toString();
                        formPro.packageWidth.text = dims[1].toString();
                        formPro.packageHeight.text = dims[2].toString();
                      },
                    );
                  }),
                  CustomExpandableTile(
                    title: tr('custom_parcel'),
                    subtitle: '',
                    icon: Icons.edit_note,
                    options: const <Map<String, dynamic>>[],
                    isExpanded: _expandedTileId == 'custom',
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        _expandedTileId = expanded ? 'custom' : null;
                      });
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        WeightSection(
                          controller: _weightSync.displayController,
                          isKg: _isKg,
                          onToggleUnit: (bool toKg) =>
                              _toggleUnit(formPro, toKg),
                        ),
                        const SizedBox(height: AppSpacing.vSm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: InlineSizeField(
                                labelKey: 'length',
                                controller: formPro.packageLength,
                                formPro: formPro,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.hXs),
                            Flexible(
                              flex: 1,
                              child: InlineSizeField(
                                labelKey: 'width',
                                controller: formPro.packageWidth,
                                formPro: formPro,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.hXs),
                            Flexible(
                              flex: 1,
                              child: InlineSizeField(
                                labelKey: 'height',
                                controller: formPro.packageHeight,
                                formPro: formPro,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
