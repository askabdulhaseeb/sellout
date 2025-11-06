import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../services/get_it.dart';
import '../../../usecase/usecase.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';
import '../../custom_dropdown.dart';

class CountryDropdownField extends StatefulWidget {
  const CountryDropdownField({
    required this.onChanged,
    this.initialValue,
    this.validator,
    super.key,
  });

  final CountryEntity? initialValue;
  final void Function(CountryEntity) onChanged;

  /// Validator should return error string if not valid, null if valid
  /// The bool argument is true if a country is selected
  final String? Function(bool?)? validator;

  @override
  State<CountryDropdownField> createState() => _CountryDropdownFieldState();
}

class _CountryDropdownFieldState extends State<CountryDropdownField> {
  List<CountryEntity> countries = <CountryEntity>[];
  CountryEntity? selectedCountry;
  GetCountiesUsecase? getCountiesUsecase;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    getCountiesUsecase = GetCountiesUsecase(locator());
    await LocalCountry().refresh();
    final DataState<List<CountryEntity>> result =
        await getCountiesUsecase!.call(const Duration(days: 1));

    if (result is DataSuccess) {
      countries = result.entity ?? LocalCountry().activeCounties;
    }

    // Set initial value if available
    if (widget.initialValue != null &&
        countries.any((CountryEntity e) =>
            e.displayName == widget.initialValue?.displayName)) {
      // find matching entity
      selectedCountry = countries.firstWhere(
          (CountryEntity e) =>
              e.displayName == widget.initialValue?.displayName,
          orElse: () => widget.initialValue!);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<CountryEntity>(
      title: 'country'.tr(),
      items: countries
          .where((CountryEntity e) => e.isActive)
          .map((CountryEntity country) => DropdownMenuItem<CountryEntity>(
                value: country,
                child: Text(country.displayName),
              ))
          .toList(),
      selectedItem: selectedCountry,
      onChanged: (CountryEntity? value) {
        if (value == null) return;
        setState(() {
          selectedCountry = value;
          widget.onChanged(value); // notify parent with entity
        });
      },
      validator: widget.validator ??
          (bool? hasValue) {
            if (hasValue == null || !hasValue) {
              return 'Please select a country';
            }
            return null;
          },
    );
  }
}
