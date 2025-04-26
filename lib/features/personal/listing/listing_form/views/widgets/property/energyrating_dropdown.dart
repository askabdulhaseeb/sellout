import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../personal/listing/listing_form/views/providers/add_listing_form_provider.dart';

class EnergyRatingDropdown extends StatefulWidget {
  const EnergyRatingDropdown({super.key});

  @override
  EnergyRatingDropdownState createState() => EnergyRatingDropdownState();
}

class EnergyRatingDropdownState extends State<EnergyRatingDropdown> {
  final List<String> energyRatings = <String>[
    '1_to_20',
    '21_to_38',
    '39_to_54',
    '55t_o_68',
    '69_to_80',
    '81_to_91',
    '92_or_higher'
  ];

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider provider =
        Provider.of<AddListingFormProvider>(context);
    return CustomDropdown<String>(
      validator: (bool? value) => null,
      title: 'select_energy_rating'.tr(),
      selectedItem: provider.selectedEnergyRating,
      // hint: 'select_energy_rating'.tr(),
      items: energyRatings.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        provider.setEnergyRating(newValue);
      },
    );
  }
}
