// no need for specialty options
// we only need three expansion tiles with small medium and large
// fourth expansion tile will be textformfield to give custom size and at the top we will show selected package size
// after all that at the bottom a weight field which will also have a toggle button for kg and lb

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/widgets/expandable_tile.dart';
import '../../../../../providers/add_listing_form_provider.dart';
import 'components/custom_size_tile.dart';
import 'components/weight_section.dart';
import 'logic/weight_unit_sync.dart';

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

  String groupBySize(List<dynamic> dims) {
    final double volume =
        (dims[0] as num).toDouble() *
        (dims[1] as num).toDouble() *
        (dims[2] as num).toDouble();
    if (volume <= 2000) {
      return 'small';
    } else if (volume <= 50000) {
      return 'medium';
    } else {
      return 'large';
    }
  }

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

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'small':
        return Icons.mail;
      case 'medium':
        return Icons.inventory_2;
      case 'large':
        return Icons.local_shipping;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro = _formPro;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // Display categories by size buckets
    final List<Map<String, String>> packCategories = <Map<String, String>>[
      <String, String>{'id': 'small', 'label': tr('small')},
      <String, String>{'id': 'medium', 'label': tr('medium')},
      <String, String>{'id': 'large', 'label': tr('large')},
    ];

    final List<Map<String, dynamic>> packPresets = <Map<String, dynamic>>[
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-sm',
        'label': tr('small_letter'),
        'dims': <num>[24, 16.5, 0.5],
        'note': tr('documents'),
      },
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-lg',
        'label': tr('large_letter'),
        'dims': <num>[35, 25, 2.5],
        'note': tr('magazines'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-sm',
        'label': tr('small_parcel'),
        'dims': <num>[45, 35, 16],
        'note': tr('clothing'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-md',
        'label': tr('medium_parcel'),
        'dims': <num>[61, 46, 46],
        'note': tr('bulk_items'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-lg',
        'label': tr('large_parcel'),
        'dims': <num>[100, 50, 50],
        'note': tr('bulky_items'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-sm',
        'label': tr('small_box'),
        'dims': <num>[22, 16, 10],
        'note': tr('accessories'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-md',
        'label': tr('medium_box'),
        'dims': <num>[35, 25, 15],
        'note': tr('shoebox_size'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-lg',
        'label': tr('large_box'),
        'dims': <num>[45, 33, 23],
        'note': tr('kitchenware'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-xl',
        'label': tr('extra_large_box'),
        'dims': <num>[60, 40, 40],
        'note': tr('bulk_appliances'),
      },
    ];
    // Prefer grouping by preset id/label tokens, fall back to volume
    String groupForPreset(Map<String, dynamic> p) {
      final String idLower = (p['id'] as String?)?.toLowerCase() ?? '';
      final String labelLower = (p['label'] as String?)?.toLowerCase() ?? '';
      // XL/Extra Large -> large
      if (idLower.contains('xl') || labelLower.contains('extra')) {
        return 'large';
      }
      // Large
      if (idLower.contains('lg') || labelLower.contains('large')) {
        return 'large';
      }
      // Medium
      if (idLower.contains('md') || labelLower.contains('medium')) {
        return 'medium';
      }
      // Small
      if (idLower.contains('sm') || labelLower.contains('small')) {
        return 'small';
      }
      // Fallback to volume thresholds
      return groupBySize(p['dims'] as List<dynamic>);
    }

    // Precompute grouped presets
    final Map<String, List<Map<String, dynamic>>> sizeGrouped =
        <String, List<Map<String, dynamic>>>{
          'small': <Map<String, dynamic>>[],
          'medium': <Map<String, dynamic>>[],
          'large': <Map<String, dynamic>>[],
        };
    for (final Map<String, dynamic> p in packPresets) {
      final String g = groupForPreset(p);
      sizeGrouped[g]!.add(p);
    }
    for (final String k in sizeGrouped.keys) {
      sizeGrouped[k]!.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        final List<dynamic> da = a['dims'];
        final List<dynamic> db = b['dims'];
        final double va =
            (da[0] as num).toDouble() *
            (da[1] as num).toDouble() *
            (da[2] as num).toDouble();
        final double vb =
            (db[0] as num).toDouble() *
            (db[1] as num).toDouble() *
            (db[2] as num).toDouble();
        return va.compareTo(vb);
      });
    }

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
                  ...packCategories.map((Map<String, String> category) {
                    final List<Map<String, dynamic>> categoryPresets =
                        sizeGrouped[category['id']] ?? <Map<String, dynamic>>[];
                    return CustomExpandableTile(
                      title: category['label']!,
                      subtitle:
                          '${categoryPresets.length} ${tr('options_available')}',
                      icon: _getCategoryIcon(category['id']!),
                      options: categoryPresets.map((
                        Map<String, dynamic> preset,
                      ) {
                        final List<dynamic> dims = preset['dims'];
                        return <String, dynamic>{
                          'id': preset['id'],
                          'label':
                              '${preset['label']} (${dims.join('×')} ${tr('cm')})',
                          'dims': dims,
                        };
                      }).toList(),
                      onOptionSelected: (Map<String, dynamic> option) {
                        final List<dynamic> dims =
                            option['dims'] as List<dynamic>;
                        formPro.packageLength.text = dims[0].toString();
                        formPro.packageWidth.text = dims[1].toString();
                        formPro.packageHeight.text = dims[2].toString();
                      },
                    );
                  }),
                  // Fourth tile: Custom size (inputs)
                  CustomSizeTile(formPro: formPro),
                ],
              ),
              const Divider(height: AppSpacing.md),
              WeightSection(
                controller: _weightSync.displayController,
                isKg: _isKg,
                onToggleUnit: (bool toKg) => _toggleUnit(formPro, toKg),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
