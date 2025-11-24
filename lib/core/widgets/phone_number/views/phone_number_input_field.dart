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

    // Only reload if initialCountry or initialValue changed
    if (widget.initialCountry != oldWidget.initialCountry ||
        widget.initialValue != oldWidget.initialValue) {
      _loadCountries();
    }
  }

  Future<void> _loadCountries() async {
    await LocalCountry().refresh();
    final DataState<List<CountryEntity>> result =
        await getCountiesUsecase.call(const Duration(days: 1));

    countries = (result is DataSuccess && result.entity != null
            ? result.entity!
            : LocalCountry().activeCountries)
        .where((CountryEntity c) => c.isActive)
        .toList();

    // Find selected country
    selectedCountry = null;

    // 1️⃣ Try initialCountry
    if (widget.initialCountry != null) {
      for (final CountryEntity c in countries) {
        if (c.alpha2.toLowerCase() ==
            widget.initialCountry!.alpha2.toLowerCase()) {
          selectedCountry = c;
          break;
        }
      }
    }

    // 2️⃣ Try initialValue if still null
    if (selectedCountry == null && widget.initialValue != null) {
      for (final CountryEntity c in countries) {
        if (c.countryCode == widget.initialValue!.countryCode) {
          selectedCountry = c;
          break;
        }
      }
    }
    // Update controller
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!.number;
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _CountryFlag(flag: country.flag),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${country.countryCode} ${country.displayName}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _CountryFlag(flag: country.flag),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${country.countryCode} ${country.displayName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
              // Prevent double display in controller for non-Text items
              initialText: '',
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
