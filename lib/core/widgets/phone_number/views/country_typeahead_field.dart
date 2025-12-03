import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../../custom_textformfield.dart';

class CountryTypeAheadField extends StatelessWidget {

  const CountryTypeAheadField({
    required this.selectedCountry,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  final CountryEntity? selectedCountry;
  final void Function(CountryEntity?) onChanged;
  @override
  Widget build(BuildContext context) {
   final countries= LocalCountry().activeCountries;
    return TypeAheadField<CountryEntity>(
      suggestionsCallback: (String pattern) {
        if (pattern.isEmpty) return countries;
        return countries
            .where(
              (CountryEntity c) =>
                  c.displayName.toLowerCase().contains(pattern.toLowerCase()) ||
                  c.countryCode.contains(pattern),
            )
            .toList();
      },

      builder:
          (
            BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
          ) {
            // Sync selected country text only once
            if (selectedCountry != null &&
                controller.text != selectedCountry!.countryCode) {
              controller.text = selectedCountry!.countryCode;
            }

            return CustomTextFormField(
              hint: 'country'.tr(),
              controller: controller,
              focusNode: focusNode,
              readOnly: false,
            );
          },

      itemBuilder: (BuildContext context, CountryEntity suggestion) {
        return ListTile(
          leading: Text(suggestion.countryCode),
          title: Text(suggestion.displayName),
        );
      },

      onSelected: (CountryEntity suggestion) {
        onChanged(suggestion);
      },
    );
  }
}
