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

    /// Categories
    const List<Map<String, String>> packCategories = <Map<String, String>>[
      <String, String>{'id': 'letters', 'label': 'Letters'},
      <String, String>{'id': 'parcels', 'label': 'Parcels'},
      <String, String>{'id': 'boxes', 'label': 'Boxes'},
      <String, String>{'id': 'special', 'label': 'Specialty'},
    ];

    /// Presets
    const List<Map<String, dynamic>> packPresets = <Map<String, dynamic>>[
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-sm',
        'label': 'Letter (S)',
        'dims': <num>[24, 16.5, 0.5],
        'note': 'Docs'
      },
      <String, dynamic>{
        'cat': 'letters',
        'id': 'letter-lg',
        'label': 'Large Letter',
        'dims': <num>[35, 25, 2.5],
        'note': 'Magazines'
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-sm',
        'label': 'Small Parcel',
        'dims': <int>[45, 35, 16],
        'note': 'Clothing'
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-md',
        'label': 'Medium Parcel',
        'dims': <int>[61, 46, 46],
        'note': 'Bulk items'
      },
      <String, dynamic>{
        'cat': 'parcels',
        'id': 'parcel-lg',
        'label': 'Large Parcel',
        'dims': <int>[100, 50, 50],
        'note': 'Bulky'
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-s',
        'label': 'Box (S)',
        'dims': <int>[22, 16, 10],
        'note': 'Accessories'
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-m',
        'label': 'Box (M)',
        'dims': <int>[35, 25, 15],
        'note': 'Shoebox size'
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-l',
        'label': 'Box (L)',
        'dims': <int>[45, 33, 23],
        'note': 'Kitchenware'
      },
      <String, dynamic>{
        'cat': 'boxes',
        'id': 'box-xl',
        'label': 'Box (XL)',
        'dims': <int>[60, 40, 40],
        'note': 'Bulk/Appliances'
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'tube-s',
        'label': 'Poster Tube (S)',
        'dims': <int>[45, 8, 8],
        'note': 'Posters/Art'
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'tube-l',
        'label': 'Poster Tube (L)',
        'dims': <int>[90, 10, 10],
        'note': 'Large prints'
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'book-mailer',
        'label': 'Book Mailer',
        'dims': <int>[28, 21, 4],
        'note': 'Books'
      },
      <String, dynamic>{
        'cat': 'special',
        'id': 'padded',
        'label': 'Padded Mailer',
        'dims': <int>[30, 23, 4],
        'note': 'Fragile smalls'
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
            'Package Details',
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
                  label: 'Length (cm)',
                  controller: formPro.packageLength,
                ),
              ),
              const SizedBox(width: AppSpacing.hXs),
              Flexible(
                flex: 1,
                child: PackageInputField(
                  label: 'Width (cm)',
                  controller: formPro.packageWidth,
                ),
              ),
              const SizedBox(width: AppSpacing.hXs),
              Flexible(
                flex: 1,
                child: PackageInputField(
                  label: 'Height (cm)',
                  controller: formPro.packageHeight,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.vSm),

          /// Weight field (separate)
          PackageInputField(
            label: 'Weight (kg)',
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
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
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
                      final List<dynamic> dims = preset['dims'] as List;
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
                          title: '${preset["label"]} (${dims.join("×")} cm)',
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
