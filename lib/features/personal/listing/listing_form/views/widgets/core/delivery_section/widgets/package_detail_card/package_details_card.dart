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

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro = _formPro;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // Define package presets with their options
    final List<Map<String, dynamic>> packPresets = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'small-parcel',
        'title': tr('small_parcel'),
        'subtitle': 'Up to 35 × 25 × 2.5 cm',
        'icon': Icons.mail,
        'options': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'small-1kg',
            'label': 'Up to 1 kg',
            'note': 'Examples: t-shirt, books, tablet',
            'dims': <num>[35, 25, 2.5],
          },
          <String, dynamic>{
            'id': 'small-2kg',
            'label': 'Up to 2 kg',
            'note': 'Examples: footwear, small kitchen appliance, hoodie',
            'dims': <num>[35, 25, 2.5],
          },
          <String, dynamic>{
            'id': 'small-5kg',
            'label': 'Up to 5 kg',
            'note': 'Examples: blender, throw blanket, LEGO set',
            'dims': <num>[35, 25, 2.5],
          },
        ],
      },
      <String, dynamic>{
        'id': 'medium-parcel',
        'title': tr('medium_parcel'),
        'subtitle': 'Up to 45 × 35 × 16 cm',
        'icon': Icons.inventory_2,
        'options': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'medium-1kg',
            'label': 'Up to 1 kg',
            'note': 'Examples: pillow, small blanket, lightweight toys',
            'dims': <num>[45, 35, 16],
          },
          <String, dynamic>{
            'id': 'medium-2kg',
            'label': 'Up to 2 kg',
            'note':
                'Examples: board games, small storage boxes, hardcover books',
            'dims': <num>[45, 35, 16],
          },
          <String, dynamic>{
            'id': 'medium-5kg',
            'label': 'Up to 5 kg',
            'note': 'Examples: bedding set, baby products, kitchenware bundle',
            'dims': <num>[45, 35, 16],
          },
          <String, dynamic>{
            'id': 'medium-10kg',
            'label': 'Up to 10 kg',
            'note': 'Examples: microwave, vacuum cleaner, desktop tower',
            'dims': <num>[45, 35, 16],
          },
        ],
      },
      <String, dynamic>{
        'id': 'large-parcel',
        'title': tr('large_parcel'),
        'subtitle': 'Up to 61 × 46 × 46 cm',
        'icon': Icons.local_shipping,
        'options': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'large-1kg',
            'label': 'Up to 1 kg small letter',
            'note': 'Examples: jewellery, cosmetics, magazines',
            'dims': <num>[61, 46, 46],
          },
          <String, dynamic>{
            'id': 'large-2kg',
            'label': 'Up to 2 kg large letter',
            'note': 'Examples: smartphone, skincare set, small gift box',
            'dims': <num>[61, 46, 46],
          },
        ],
      },
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
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            spacing: AppSpacing.vSm,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ...packPresets.map((Map<String, dynamic> preset) {
                    return CustomExpandableTile(
                      title: preset['title'] as String,
                      subtitle: preset['subtitle'] as String,
                      icon: preset['icon'] as IconData,
                      options: preset['options'] as List<Map<String, dynamic>>,
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
