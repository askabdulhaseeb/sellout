import 'package:flutter/material.dart';

import '../../../../services/get_it.dart';
import '../../../usecase/usecase.dart';
import '../../costom_textformfield.dart';
import '../../custom_dropdown.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/entities/phone_number_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';

class PhoneNumberInputField extends StatefulWidget {
  const PhoneNumberInputField({
    required this.onChange,
    this.initialValue,
    this.labelText = '',
    super.key,
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
  GetCountiesUsecase? getCountiesUsecase;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _postInit() {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue?.number ?? '';
      final String code = widget.initialValue?.countryCode ?? '';
      CountryEntity? c = LocalCountry().country(code);
      if (c != null && countries.contains(c)) {
        setState(() {
          selectedCountry = c;
        });
      } else {
        final int index = countries.indexWhere((CountryEntity e) {
          if (e.countryCode == code) {
            selectedCountry = e;
            return true;
          }
          return false;
        });
        if (index != -1) {
          setState(() {
            selectedCountry = countries[index];
          });
        }
      }
    }
  }

  Future<void> _init() async {
    getCountiesUsecase = GetCountiesUsecase(locator());
    await LocalCountry().refresh();
    await countiries();
    if (!mounted) return; // ✅ check before calling setState
    _postInit();
  }

  Future<void> countiries() async {
    DataState<List<CountryEntity>> cou =
        await getCountiesUsecase!.call(const Duration(days: 1));
    if (cou is DataSuccess) {
      countries = cou.entity ?? LocalCountry().activeCounties;
    }
    if (!mounted) return; // ✅ check before calling setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CustomDropdown<CountryEntity>(
                title: '',
                hint: '',
                height: 48,
                width: 125,
                isSearchable: false,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                items: countries
                    .where((CountryEntity e) => e.isActive)
                    .map((CountryEntity e) {
                  return DropdownMenuItem<CountryEntity>(
                    value: e,
                    child: Row(
                      children: <Widget>[
                        Text(e.shortName.toUpperCase(),
                            style: TextTheme.of(context).bodyMedium),
                        Text(' (${e.countryCode})',
                            style: TextTheme.of(context).bodyMedium),
                      ],
                    ),
                  );
                }).toList(),
                selectedItem: selectedCountry,
                onChanged: (CountryEntity? value) {
                  if (value == null) return;
                  setState(() {
                    selectedCountry = value;
                    widget.onChange(PhoneNumberEntity(
                      countryCode: value.countryCode,
                      number: controller.text,
                    ));
                  });
                },
                validator: (_) => null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                readOnly: selectedCountry == null,
                onChanged: (String p0) => widget.onChange(PhoneNumberEntity(
                  countryCode: selectedCountry?.countryCode ?? '',
                  number: p0,
                )),
                keyboardType: TextInputType.number,
                // validator: (String? value) => AppValidator.customRegExp(
                //     selectedCountry?.numberFormat ?? '',
                //     '${selectedCountry?.countryCode}$value'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
