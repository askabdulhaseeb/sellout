import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../services/get_it.dart';
import '../../../utilities/app_validators.dart';
import '../../../usecase/usecase.dart';
import '../../custom_textformfield.dart';
import '../../custom_dropdown.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/entities/phone_number_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';
import '../../../sources/data_state.dart';

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

  @override
  void didUpdateWidget(covariant PhoneNumberInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool countryChanged = widget.initialCountry?.countryCode !=
        oldWidget.initialCountry?.countryCode;
    final bool phoneChanged =
        widget.initialValue?.countryCode != oldWidget.initialValue?.countryCode;

    if (countryChanged || phoneChanged) {
      _loadCountries();
    }
  }

  Future<void> _loadCountries() async {
    await LocalCountry().refresh();
    final DataState<List<CountryEntity>> result =
        await getCountiesUsecase.call(const Duration(days: 1));
    countries = result is DataSuccess && result.entity != null
        ? result.entity!
        : LocalCountry().activeCountries;

    countries = countries.where((CountryEntity e) => e.isActive).toList();

    // Initialize selected country
    if (widget.initialCountry != null) {
      selectedCountry = countries.firstWhere(
        (CountryEntity c) =>
            c.countryCode == widget.initialCountry!.countryCode,
        orElse: () =>
            countries.isNotEmpty ? countries.first : CountryEntity.empty(),
      );
    } else if (widget.initialValue != null) {
      controller.text = widget.initialValue!.number;
      selectedCountry = countries.firstWhere(
        (CountryEntity c) => c.countryCode == widget.initialValue!.countryCode,
        orElse: () =>
            countries.isNotEmpty ? countries.first : CountryEntity.empty(),
      );
    } else if (countries.isNotEmpty) {
      CountryEntity? pk;
      for (final CountryEntity c in countries) {
        final String name = c.displayName.trim().toLowerCase();
        final String cname = c.countryName.trim().toLowerCase();
        final String a2 = c.alpha2.trim().toLowerCase();
        final String iso = c.isoCode.trim().toLowerCase();
        final String dial = c.countryCode.trim().toLowerCase();
        final bool inCodes = c.countryCodes
            .any((s) => s.trim().toLowerCase() == 'pk' || s.trim() == '+92');
        if (name == 'pakistan' ||
            cname == 'pakistan' ||
            a2 == 'pk' ||
            iso == 'pk' ||
            dial == '+92' ||
            inCodes) {
          pk = c;
          break;
        }
      }
      selectedCountry = pk ?? countries.first;
    }

    if (mounted) setState(() {});
  }

  int? _maxDigits(CountryEntity? c) {
    if (c == null) return null;
    final String format = c.numberFormat.format;
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
            child: Text(widget.labelText,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        Row(
          children: <Widget>[
            CustomDropdown<CountryEntity>(
              sufixIcon: true,
              title: '',
              hint: '',
              width: 125,
              searchBy: (DropdownMenuItem<CountryEntity> item) {
                final CountryEntity? country = item.value;
                return country == null
                    ? ''
                    : '${country.countryCode} ${country.displayName}';
              },
              selectedItemBuilder: (CountryEntity? country) {
                if (country == null) return const SizedBox.shrink();
                return Row(
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
                );
              },
              selectedItemPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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

class _CountryFlag extends StatelessWidget {
  const _CountryFlag({required this.flag});
  final String flag;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 16,
        width: 20,
        child: SvgPicture.network(
          flag,
          fit: BoxFit.cover,
          placeholderBuilder: (BuildContext context) => const SizedBox(
            width: 20,
            height: 16,
            child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
          ),
        ),
      ),
    );
  }
}
