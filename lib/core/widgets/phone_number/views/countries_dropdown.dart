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
    selectedCountry = widget.initialValue;
    _init();
  }

  @override
  void didUpdateWidget(CountryDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _updateSelectedCountry();
      setState(() {});
    }
  }

  Future<void> _init() async {
    getCountiesUsecase = GetCountiesUsecase(locator());
    await LocalCountry().refresh();

    final DataState<List<CountryEntity>> result =
        await getCountiesUsecase!.call(const Duration(days: 1));

    if (result is DataSuccess) {
      countries = result.entity ?? LocalCountry().activeCounties;
    }

    _updateSelectedCountry();
    setState(() {});
  }

  void _updateSelectedCountry() {
    if (widget.initialValue == null) {
      selectedCountry = null;
      return;
    }

    if (countries.isNotEmpty &&
        countries
            .any((e) => e.displayName == widget.initialValue?.displayName)) {
      selectedCountry = countries.firstWhere(
        (e) => e.displayName == widget.initialValue?.displayName,
        orElse: () => widget.initialValue!,
      );
    } else {
      selectedCountry = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<CountryEntity>(
      title: 'country'.tr(),
      items: countries
          .where((e) => e.isActive)
          .map((country) => DropdownMenuItem<CountryEntity>(
                value: country,
                child: Text(
                  country.displayName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ))
          .toList(),
      selectedItem: selectedCountry,
      onChanged: (CountryEntity? value) {
        if (value == null) return;
        setState(() {
          selectedCountry = value;
          widget.onChanged(value);
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
