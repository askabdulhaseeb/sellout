import 'package:flutter/material.dart';
import '../../../../services/get_it.dart';
import '../../../utilities/app_validators.dart';
import '../../../usecase/usecase.dart';
import '../../custom_network_image.dart';
import '../../custom_textformfield.dart';
import '../../custom_dropdown.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/entities/phone_number_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';
import '../../../sources/data_state.dart';

class PhoneNumberInputField extends StatefulWidget {
  const PhoneNumberInputField({
    required this.onChange, super.key,
    this.initialValue,
    this.labelText = '',
  });
  final String labelText;
  final PhoneNumberEntity? initialValue;
  final void Function(PhoneNumberEntity) onChange;

  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  final TextEditingController controller = TextEditingController();
  List<CountryEntity> countries = <CountryEntity>[];
  CountryEntity? selectedCountry;
  late GetCountiesUsecase getCountiesUsecase;

  @override
  void initState() {
    super.initState();
    getCountiesUsecase = GetCountiesUsecase(locator());
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    await LocalCountry().refresh();
    final DataState<List<CountryEntity>> result =
        await getCountiesUsecase.call(const Duration(days: 1));
    if (result is DataSuccess && result.entity != null) {
      countries = result.entity!;
    } else {
      countries = LocalCountry().activeCountries;
    }
    countries = countries.where((CountryEntity e) => e.isActive).toList();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!.number;
      final String target =
          widget.initialValue!.countryCode.trim().toLowerCase();
      CountryEntity? match;
      for (final CountryEntity entity in countries) {
        final Iterable<String> identifiers = <String>[
          entity.countryCode,
          entity.shortName,
          entity.displayName,
          entity.countryName,
          ...entity.countryCodes,
        ].map((String e) => e.trim().toLowerCase());
        if (identifiers.contains(target)) {
          match = entity;
          break;
        }
      }
      match ??= countries.isNotEmpty ? countries.first : null;
      selectedCountry = match;
    }

    if (mounted) setState(() {});
  }

  int? _maxDigits(CountryEntity? c) {
    if (c == null) return null;
    final NumberFormatEntity formatEntity = c.numberFormat;
    final String format = formatEntity.format;
    final int matches = RegExp(r'[Xx]').allMatches(format).length;
    return matches > 0 ? matches : null;
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
            CustomDropdown<CountryEntity>(
              title: '',
              hint: '',
              width: 125,
              items: countries.map((CountryEntity country) {
                return DropdownMenuItem<CountryEntity>(
                  value: country,
                  child: Row(
                    children: <Widget>[
                      _CountryFlag(flag: country.flag),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${country.countryCode} ${country.displayName}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              selectedItem: selectedCountry,
              onChanged: (CountryEntity? value) {
                setState(() => selectedCountry = value);
                widget.onChange(PhoneNumberEntity(
                  countryCode: value?.countryCode ?? '',
                  number: controller.text,
                ));
              },
              validator: (bool? val) => AppValidator.requireSelection(val),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                readOnly: selectedCountry == null,
                maxLength: _maxDigits(selectedCountry),
                keyboardType: TextInputType.number,
                onChanged: (String value) => widget.onChange(PhoneNumberEntity(
                  countryCode: selectedCountry?.countryCode ?? '',
                  number: value,
                )),
                validator: (String? value) {
                  if ((value ?? '').isEmpty) {
                    return 'Enter a phone number';
                  }
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

class _CountryFlag extends StatelessWidget {
  const _CountryFlag({required this.flag});
  final String flag;

  @override
  Widget build(BuildContext context) {
    final String trimmed = flag.trim();
    if (trimmed.isEmpty) {
      return _placeholder();
    }
    if (trimmed.startsWith('https')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: const CustomNetworkImage(
          size: 18,
          imageURL:
              'https://upload.wikimedia.org/wikipedia/commons/3/32/Flag_of_Pakistan.svg',
          fit: BoxFit.cover,
        ),
      );
    }
    if (trimmed.contains('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          trimmed,
          width: 24,
          height: 16,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackText(trimmed),
        ),
      );
    }
    return _fallbackText(trimmed);
  }

  Widget _placeholder() => Container(
        width: 24,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      );

  Widget _fallbackText(String value) {
    if (value.length <= 6 && !value.contains('/')) {
      return Text(
        value,
        style: const TextStyle(fontSize: 16),
      );
    }
    return _placeholder();
  }
}
