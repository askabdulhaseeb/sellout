// no need for specialty options
// we only need three expansion tiles with small medium and large
// fourth expansion tile will be textformfield to give custom size and at the top we will show selected package size
// after all that at the bottom a weight field which will also have a toggle button for kg and lb

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../providers/add_listing_form_provider.dart';
import 'components/selected_banner.dart';
import 'components/info_notice.dart';
import 'components/size_category_tile.dart';
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

    // Helper: selected dims text and matching preset label
    String? selectedDimsText() {
      final String l = formPro.packageLength.text.trim();
      final String w = formPro.packageWidth.text.trim();
      final String h = formPro.packageHeight.text.trim();
      if (l.isEmpty || w.isEmpty || h.isEmpty) return null;
      return '$l × $w × $h ${tr('cm')}';
    }

    String? matchedPresetLabel() {
      final String l = formPro.packageLength.text.trim();
      final String w = formPro.packageWidth.text.trim();
      final String h = formPro.packageHeight.text.trim();
      if (l.isEmpty || w.isEmpty || h.isEmpty) return null;
      for (final Map<String, dynamic> p in packPresets) {
        final List<dynamic> d = p['dims'];
        if (d[0].toString() == l &&
            d[1].toString() == w &&
            d[2].toString() == h) {
          return p['label'] as String?;
        }
      }
      return null;
    }

    // Size grouping based on volume (cm^3)
    String groupBySize(List<dynamic> dims) {
      final double v = (dims[0] as num).toDouble() *
          (dims[1] as num).toDouble() *
          (dims[2] as num).toDouble();
      const double smallMax = 20000; // up to 20k cm^3
      const double mediumMax = 100000; // up to 100k cm^3
      if (v <= smallMax) return 'small';
      if (v <= mediumMax) return 'medium';
      return 'large';
    }

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
        final double va = (da[0] as num).toDouble() *
            (da[1] as num).toDouble() *
            (da[2] as num).toDouble();
        final double vb = (db[0] as num).toDouble() *
            (db[1] as num).toDouble() *
            (db[2] as num).toDouble();
        return va.compareTo(vb);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('package_details'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: scheme.outline),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            spacing: AppSpacing.vSm,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                tr('package_details'),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Builder(builder: (BuildContext context) {
                final String? dims = selectedDimsText();
                final String? preset = matchedPresetLabel();
                return SelectedBanner(dimsText: dims, presetLabel: preset);
              }),
              const InfoNotice(),
              Column(
                children: <Widget>[
                  ...packCategories.map((Map<String, String> category) {
                    final List<Map<String, dynamic>> categoryPresets =
                        sizeGrouped[category['id']] ?? <Map<String, dynamic>>[];
                    return SizeCategoryTile(
                      label: category['label']!,
                      presets: categoryPresets,
                      isSelectedDims: (List<dynamic> d) =>
                          formPro.packageLength.text == d[0].toString() &&
                          formPro.packageWidth.text == d[1].toString() &&
                          formPro.packageHeight.text == d[2].toString(),
                      onSelectDims: (List<dynamic> d) {
                        formPro.packageLength.text = d[0].toString();
                        formPro.packageWidth.text = d[1].toString();
                        formPro.packageHeight.text = d[2].toString();
                      },
                    );
                  }).toList(),

                  // Fourth tile: Custom size (inputs)
                  CustomSizeTile(formPro: formPro),
                ],
              ),
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
