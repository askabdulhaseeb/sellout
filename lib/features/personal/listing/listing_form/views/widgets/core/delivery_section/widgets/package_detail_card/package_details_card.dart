import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../core/widgets/expandable_tile.dart';
import '../../../../../providers/add_listing_form_provider.dart';
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
      case 'letters':
        return Icons.mail;
      case 'parcels':
        return Icons.inventory_2;
      case 'boxes':
        return Icons.local_shipping;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro = _formPro;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // Display categories by package type
    final List<Map<String, String>> packCategories = <Map<String, String>>[
      <String, String>{
        'id': 'letters',
        'label': tr('letters'),
        'subtitle': tr('letters_subtitle'),
      },
      <String, String>{
        'id': 'parcels',
        'label': tr('parcels'),
        'subtitle': tr('parcels_subtitle'),
      },
      <String, String>{
        'id': 'boxes',
        'label': tr('boxes'),
        'subtitle': tr('boxes_subtitle'),
      },
    ];

    final List<Map<String, dynamic>> packPresets = <Map<String, dynamic>>[
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-sm',
        'label': tr('up_to_1kg_small_letter'),
        'dims': <num>[24, 16.5, 0.5],
        'note': tr('letter_sm_examples'),
      },
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-lg',
        'label': tr('up_to_2kg_large_letter'),
        'dims': <num>[35, 25, 2.5],
        'note': tr('letter_lg_examples'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-sm',
        'label': tr('up_to_5kg_small_parcel'),
        'dims': <num>[45, 35, 16],
        'note': tr('parcel_sm_examples'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-md',
        'label': tr('up_to_10kg_medium_parcel'),
        'dims': <num>[61, 46, 46],
        'note': tr('parcel_md_examples'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-lg',
        'label': tr('up_to_20kg_large_parcel'),
        'dims': <num>[100, 50, 50],
        'note': tr('parcel_lg_examples'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-sm',
        'label': tr('small_box_22x16x10'),
        'dims': <num>[22, 16, 10],
        'note': tr('box_sm_examples'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-md',
        'label': tr('medium_box_35x25x15'),
        'dims': <num>[35, 25, 15],
        'note': tr('box_md_examples'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-lg',
        'label': tr('large_box_45x33x23'),
        'dims': <num>[45, 33, 23],
        'note': tr('box_lg_examples'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-xl',
        'label': tr('extra_large_box_60x40x40'),
        'dims': <num>[60, 40, 40],
        'note': tr('box_xl_examples'),
      },
    ];

    // Group presets by their category
    final Map<String, List<Map<String, dynamic>>> sizeGrouped =
        <String, List<Map<String, dynamic>>>{
          'letters': <Map<String, dynamic>>[],
          'parcels': <Map<String, dynamic>>[],
          'boxes': <Map<String, dynamic>>[],
        };
    for (final Map<String, dynamic> p in packPresets) {
      final String cat = p['cat'] as String;
      if (sizeGrouped.containsKey(cat)) {
        sizeGrouped[cat]!.add(p);
      }
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
                      subtitle: category['subtitle']!,
                      icon: _getCategoryIcon(category['id']!),
                      options: categoryPresets.map((
                        Map<String, dynamic> preset,
                      ) {
                        return <String, dynamic>{
                          'id': preset['id'],
                          'label': preset['label'],
                          'note': preset['note'],
                          'dims': preset['dims'],
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
                  CustomExpandableTile(
                    title: tr('custom_size'),
                    subtitle: tr('enter_custom_size'),
                    icon: Icons.edit_note,
                    options: const <Map<String, dynamic>>[],
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
                              child: _InlineSizeField(
                                labelKey: 'length',
                                controller: formPro.packageLength,
                                formPro: formPro,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.hXs),
                            Flexible(
                              flex: 1,
                              child: _InlineSizeField(
                                labelKey: 'width',
                                controller: formPro.packageWidth,
                                formPro: formPro,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.hXs),
                            Flexible(
                              flex: 1,
                              child: _InlineSizeField(
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
}

class _InlineSizeField extends StatelessWidget {
  const _InlineSizeField({
    required this.labelKey,
    required this.controller,
    required this.formPro,
  });

  final String labelKey;
  final TextEditingController controller;
  final AddListingFormProvider formPro;

  @override
  Widget build(BuildContext context) {
    String? validator(String? value) {
      if (formPro.deliveryType != DeliveryType.paid &&
          formPro.deliveryType != DeliveryType.freeDelivery) {
        return null;
      }
      final String input = (value ?? '').trim();
      if (input.isEmpty) return AppValidator.isEmpty(input);
      final double? v = double.tryParse(input.replaceAll(',', '.'));
      if (v == null || v <= 0) return 'invalid_value'.tr();
      return null;
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      decoration: InputDecoration(
        labelText: tr(labelKey),
        suffixText: tr('cm'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.vSm,
        ),
      ),
    );
  }
}
