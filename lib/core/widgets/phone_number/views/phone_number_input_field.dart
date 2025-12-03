import 'package:flutter/material.dart';
import '../../custom_textformfield.dart';
import '../data/sources/local_country.dart';
import 'country_typeahead_field.dart';
import '../domain/entities/country_entity.dart';
import '../domain/entities/phone_number_entity.dart';

class PhoneNumberInputField extends StatelessWidget {
  const PhoneNumberInputField({
    required this.onChange,
    this.initialValue,
    this.initialCountry,
    this.labelText = '',
    super.key,
  });
  final String labelText;
  final PhoneNumberEntity? initialValue;
  final CountryEntity? initialCountry;
  final void Function(PhoneNumberEntity) onChange;

  int? _maxDigits(CountryEntity? c) {
    if (c == null) return null;
    final String format = c.numberFormat.format;
    final int matches = RegExp(r'[Xx]').allMatches(format).length;
    return matches > 0 ? matches : null;
  }

  @override
  Widget build(BuildContext context) {
    final List<CountryEntity> countries = LocalCountry().activeCountries;
    final TextEditingController controller = TextEditingController(
      text: initialValue?.number ?? '',
    );
    CountryEntity? selectedCountry =
        initialCountry ??
        (initialValue != null
            ? (countries
                      .where((CountryEntity c) => c.countryCode == initialValue!.countryCode)
                      .isNotEmpty
                  ? countries
                        .where(
                          (CountryEntity c) => c.countryCode == initialValue!.countryCode,
                        )
                        .first
                  : (countries.isNotEmpty ? countries.first : null))
            : (countries.isNotEmpty ? countries.first : null));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              labelText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 180,
              child: CountryTypeAheadField(
                selectedCountry: selectedCountry,
                onChanged: (CountryEntity? value) {
                  selectedCountry = value;
                  onChange(
                    PhoneNumberEntity(
                      countryCode: value?.countryCode ?? '',
                      number: controller.text,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                readOnly: selectedCountry == null,
                maxLength: _maxDigits(selectedCountry),
                keyboardType: TextInputType.number,
                onChanged: (String value) => onChange(
                  PhoneNumberEntity(
                    countryCode: selectedCountry?.countryCode ?? '',
                    number: value,
                  ),
                ),
                validator: (String? value) {
                  if ((value ?? '').isEmpty) return 'Enter a phone number';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
