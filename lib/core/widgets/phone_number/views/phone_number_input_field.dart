import 'package:flutter/material.dart';
import '../../custom_textformfield.dart';
import '../data/sources/local_country.dart';
import 'country_typeahead_field.dart';
import '../domain/entities/country_entity.dart';
import '../domain/entities/phone_number_entity.dart';

class PhoneNumberInputField extends StatefulWidget {
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

  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  late TextEditingController controller;
  CountryEntity? selectedCountry;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue?.number ?? '');
    final List<CountryEntity> countries = LocalCountry().getAll();
    if (widget.initialCountry != null) {
      selectedCountry = widget.initialCountry;
    } else if (widget.initialValue != null) {
      final Iterable<CountryEntity> matches = countries.where(
        (CountryEntity c) => c.countryCode == widget.initialValue!.countryCode,
      );
      selectedCountry = matches.isNotEmpty ? matches.first : null;
    } else {
      selectedCountry = null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              widget.labelText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: CountryTypeAheadField(
                selectedCountry: selectedCountry,
                onChanged: (CountryEntity? value) {
                  if (mounted) {
                    setState(() {
                      selectedCountry = value;
                    });
                  }
                  widget.onChange(
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
                keyboardType: TextInputType.number,
                onChanged: (String value) => widget.onChange(
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
