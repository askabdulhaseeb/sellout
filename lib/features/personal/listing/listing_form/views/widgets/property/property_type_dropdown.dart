import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../personal/listing/listing_form/views/providers/add_listing_form_provider.dart';

class PropertyTypeDropdown extends StatefulWidget {
  const PropertyTypeDropdown({super.key});

  @override
  State<PropertyTypeDropdown> createState() => _PropertyTypeDropdownState();
}

class _PropertyTypeDropdownState extends State<PropertyTypeDropdown> {
  final List<String> propertyTypes = <String>[
    'detached',
    'semi_detached',
    'terraced',
    'flats',
    'bungalow',
    'farms/land',
    'park_homes'
  ];

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider provider =
        Provider.of<AddListingFormProvider>(context);

    return CustomDropdown<String>(
      validator: (bool? value) => null,
      title: 'select_property_type'.tr(),
      selectedItem: provider.selectedPropertyType,
      hint: 'select_property_type'.tr(),
      items: propertyTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.tr()),
        );
      }).toList(),
      onChanged: (String? newValue) {
        provider.setPropertyType(newValue);
      },
    );
  }
}
