import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../providers/add_listing_form_provider.dart';

class PackageDetailsCard extends StatelessWidget {
  const PackageDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    final Map<String, List<int>> parcelPresets = <String, List<int>>{
      'parcel.large': <int>[35, 25, 2],
      'parcel.small': <int>[45, 35, 16],
      'parcel.medium': <int>[61, 46, 46],
    };
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'parcel.title'.tr(),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('parcel.max_size'.tr()),
          const SizedBox(height: 12),

          /// Input Fields
          Row(
            children: <Widget>[
              PackageInputField(
                label: 'parcel.length'.tr(),
                controller: formPro.packageLength,
              ),
              const SizedBox(width: 8),
              PackageInputField(
                label: 'parcel.width'.tr(),
                controller: formPro.packageWidth,
              ),
              const SizedBox(width: 8),
              PackageInputField(
                label: 'parcel.height'.tr(),
                controller: formPro.packageHeight,
              ),
            ],
          ),

          /// Preset Buttons
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.start,
            children:
                parcelPresets.entries.map((MapEntry<String, List<int>> entry) {
              return IntrinsicWidth(
                child: SizedBox(
                  height: 32,
                  child: CustomElevatedButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    margin: EdgeInsets.zero,
                    isLoading: false,
                    bgColor: Colors.transparent,
                    border: Border.all(color: scheme.outlineVariant),
                    title: '${entry.key.tr()} ${entry.value.join('×')} cm',
                    textStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    onTap: () {
                      formPro.packageLength.text = entry.value[0].toString();
                      formPro.packageWidth.text = entry.value[1].toString();
                      formPro.packageHeight.text = entry.value[2].toString();
                    },
                  ),
                ),
              );
            }).toList(),
          ),
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
    return Expanded(
      child: CustomTextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        labelText: label,
      ),
    );
  }
}
