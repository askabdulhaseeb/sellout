import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../providers/add_listing_form_provider.dart';

class PackageDetailsCard extends StatelessWidget {
  const PackageDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    /// Categories (localized labels)
    final List<Map<String, String>> packCategories = <Map<String, String>>[
      <String, String>{'id': 'letters', 'label': tr('letters')},
      <String, String>{'id': 'parcels', 'label': tr('parcels')},
      <String, String>{'id': 'boxes', 'label': tr('boxes')},
      <String, String>{'id': 'special', 'label': tr('specialty')},
    ];

    /// Presets (localized labels + notes)
    final List<Map<String, dynamic>> packPresets = <Map<String, dynamic>>[
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-sm',
        'label': tr('letter_s'),
        'dims': <num>[24, 16.5, 0.5],
        'note': tr('docs'),
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
        'dims': <int>[45, 35, 16],
        'note': tr('clothing'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-md',
        'label': tr('medium_parcel'),
        'dims': <int>[61, 46, 46],
        'note': tr('bulk_items'),
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-lg',
        'label': tr('large_parcel'),
        'dims': <int>[100, 50, 50],
        'note': tr('bulky'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-s',
        'label': tr('box_s'),
        'dims': <int>[22, 16, 10],
        'note': tr('accessories'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-m',
        'label': tr('box_m'),
        'dims': <int>[35, 25, 15],
        'note': tr('shoebox_size'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-l',
        'label': tr('box_l'),
        'dims': <int>[45, 33, 23],
        'note': tr('kitchenware'),
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-xl',
        'label': tr('box_xl'),
        'dims': <int>[60, 40, 40],
        'note': tr('bulk_appliances'),
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'tube-s',
        'label': tr('poster_tube_s'),
        'dims': <int>[45, 8, 8],
        'note': tr('posters_art'),
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'tube-l',
        'label': tr('poster_tube_l'),
        'dims': <int>[90, 10, 10],
        'note': tr('large_prints'),
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'book-mailer',
        'label': tr('book_mailer'),
        'dims': <int>[28, 21, 4],
        'note': tr('books'),
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'padded',
        'label': tr('padded_mailer'),
        'dims': <int>[30, 23, 4],
        'note': tr('fragile_smalls'),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tr('package_details'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.vSm),

          /// Length, Width, Height fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: PackageInputField(
                  label: tr('length_cm'),
                  controller: formPro.packageLength,
                ),
              ),
              const SizedBox(width: AppSpacing.hXs),
              Flexible(
                flex: 1,
                child: PackageInputField(
                  label: tr('width_cm'),
                  controller: formPro.packageWidth,
                ),
              ),
              const SizedBox(width: AppSpacing.hXs),
              Flexible(
                flex: 1,
                child: PackageInputField(
                  label: tr('height_cm'),
                  controller: formPro.packageHeight,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.vSm),

          /// Weight field
          PackageInputField(
            label: tr('weight_kg'),
            controller: formPro.packageWeight,
          ),

          const SizedBox(height: AppSpacing.vMd),

          /// Expandable categories
          ...packCategories.map((Map<String, String> category) {
            final List<Map<String, dynamic>> categoryPresets = packPresets
                .where((Map<String, dynamic> preset) =>
                    preset['cat'] == category['id'])
                .toList();

            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  category['label']!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children:
                        categoryPresets.map((Map<String, dynamic> preset) {
                      final List<dynamic> dims = preset['dims'];
                      return SizedBox(
                        height: 34,
                        child: CustomElevatedButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 0,
                          ),
                          margin: EdgeInsets.zero,
                          isLoading: false,
                          bgColor: Colors.transparent,
                          border: Border.all(color: scheme.outlineVariant),
                          title:
                              '${preset["label"]} (${dims.join("×")} ${tr("cm")})',
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                          onTap: () {
                            formPro.packageLength.text = dims[0].toString();
                            formPro.packageWidth.text = dims[1].toString();
                            formPro.packageHeight.text = dims[2].toString();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PackageInputField extends StatelessWidget {
  const PackageInputField({
    required this.label,
    required this.controller,
    super.key,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      labelText: label,
    );
  }
}
