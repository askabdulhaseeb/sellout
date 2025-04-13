import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingVehicleBasicInfoSection extends StatefulWidget {
  const AddListingVehicleBasicInfoSection({super.key});

  @override
  State<AddListingVehicleBasicInfoSection> createState() =>
      _AddListingVehicleBasicInfoSectionState();
}

class _AddListingVehicleBasicInfoSectionState
    extends State<AddListingVehicleBasicInfoSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
        builder: (BuildContext context, AddListingFormProvider formPro, _) {
      // final List<int> years =
      //     List<int>.generate(80, (int index) => DateTime.now().year - index);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTextFormField(
            controller: formPro.price,
            labelText: 'price'.tr(),
            hint: 'Ex. 12000.0',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            prefixText: LocalAuth.currency.toUpperCase(),
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ),
          CustomTextFormField(
            controller: formPro.year,
            labelText: 'year'.tr(),
            hint: 'Ex. 2025',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ),
          CustomTextFormField(
            controller: formPro.bodytype,
            labelText: 'body_type'.tr(),
            hint: 'Ex. Sedan',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ),
          CustomTextFormField(
            controller: formPro.emission,
            labelText: 'emission'.tr(),
            hint: 'Ex. ',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ),
          CustomTextFormField(
            controller: formPro.make,
            labelText: 'make'.tr(),
            hint: 'Ex. Toyota',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ),
          CustomTextFormField(
            controller: formPro.model,
            labelText: 'model'.tr(),
            hint: 'Ex. Toyota Camry or Corolla',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Consumer<AddListingFormProvider>(
              builder: (BuildContext context, AddListingFormProvider provider,
                  Widget? child) {
                return FutureBuilder<List<ColorOptionEntity>>(
                  future: provider.colorOptions(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ColorOptionEntity>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final List<ColorOptionEntity> colorOptionsList =
                        snapshot.data!;

                    return CustomDropdown<String>(
                      isSearchable: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      hint: 'color'.tr(),
                      selectedItem: formPro.selectedVehicleColor,
                      title: 'color'.tr(),
                      validator: (_) => null,
                      items: colorOptionsList.map((ColorOptionEntity color) {
                        return DropdownMenuItem<String>(
                          value: color.value,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(int.parse(
                                    '0xFF${color.value.replaceAll('#', '')}')),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(color.label)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        formPro.setVehicleColor(newValue ?? '');
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      );
    });
  }
}
