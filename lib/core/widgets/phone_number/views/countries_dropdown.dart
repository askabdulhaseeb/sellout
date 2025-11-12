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
    print(
        '🔄 CountryDropdown initState - initialValue: ${widget.initialValue?.displayName}');
    print(
        '🔄 CountryDropdown initState - selectedCountry: ${selectedCountry?.displayName}');
    _init();
  }

  @override
  void didUpdateWidget(CountryDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(
        '🔄 CountryDropdown didUpdateWidget - oldValue: ${oldWidget.initialValue?.displayName}');
    print(
        '🔄 CountryDropdown didUpdateWidget - newValue: ${widget.initialValue?.displayName}');
    if (widget.initialValue != oldWidget.initialValue) {
      print(
          '🔄 CountryDropdown didUpdateWidget - values different, updating selected country');
      _updateSelectedCountry();
      setState(() {});
    }
  }

  Future<void> _init() async {
    print('🔄 CountryDropdown _init - starting initialization');
    getCountiesUsecase = GetCountiesUsecase(locator());
    await LocalCountry().refresh();

    final DataState<List<CountryEntity>> result =
        await getCountiesUsecase!.call(const Duration(days: 1));

    if (result is DataSuccess) {
      countries = result.entity ?? LocalCountry().activeCounties;
      print(
          '🔄 CountryDropdown _init - loaded ${countries.length} countries from API');
    } else {
      countries = LocalCountry().activeCounties;
      print(
          '🔄 CountryDropdown _init - loaded ${countries.length} countries from local cache');
    }

    print(
        '🔄 CountryDropdown _init - countries loaded, updating selected country');
    _updateSelectedCountry();
    setState(() {});
  }

  void _updateSelectedCountry() {
    print('🔄 CountryDropdown _updateSelectedCountry - starting update');
    print(
        '🔄 CountryDropdown _updateSelectedCountry - initialValue: ${widget.initialValue?.displayName}');
    print(
        '🔄 CountryDropdown _updateSelectedCountry - countries.length: ${countries.length}');

    if (widget.initialValue == null) {
      selectedCountry = null;
      print(
          '🔄 CountryDropdown _updateSelectedCountry - initialValue is null, setting selectedCountry to null');
      return;
    }

    // Debug: Print all country display names
    print('🔄 Available countries:');
    for (int i = 0; i < countries.length; i++) {
      final CountryEntity country = countries[i];
      print(
          '🔄 Country $i: "${country.displayName}" (isActive: ${country.isActive})');
    }

    print('🔄 Looking for: "${widget.initialValue?.displayName}"');

    final initialDisplayName = widget.initialValue?.displayName;
    if (countries.isNotEmpty && initialDisplayName != null) {
      selectedCountry = countries.firstWhere(
        (CountryEntity e) =>
            e.displayName.trim().toLowerCase() ==
            initialDisplayName.trim().toLowerCase(),
        orElse: () => widget.initialValue!,
      );
      print(
          '🔄 CountryDropdown _updateSelectedCountry - found matching country: ${selectedCountry?.displayName}');
    } else {
      selectedCountry = widget.initialValue;
      print(
          '🔄 CountryDropdown _updateSelectedCountry - no matching country found, using initialValue: ${selectedCountry?.displayName}');

      // Debug: Let's see why no match was found
      print('🔄 Detailed comparison:');
      for (final CountryEntity country in countries) {
        final bool match =
            country.displayName == widget.initialValue?.displayName;
        final String? initialDisplayName = widget.initialValue?.displayName;
        final bool trimmedMatch = initialDisplayName != null
            ? country.displayName.trim().toLowerCase() ==
                initialDisplayName.trim().toLowerCase()
            : false;
        print(
            '🔄 "${country.displayName}" == "${widget.initialValue?.displayName}" = $match (trimmed/lowercase = $trimmedMatch)');
      }
    }

    print(
        '🔄 CountryDropdown _updateSelectedCountry - final selectedCountry: ${selectedCountry?.displayName}');
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🔄 CountryDropdown build - selectedCountry: ${selectedCountry?.displayName}');
    print('🔄 CountryDropdown build - countries.length: ${countries.length}');
    print(
        '🔄 CountryDropdown build - active countries: ${countries.where((CountryEntity e) => e.isActive).length}');

    return CustomDropdown<CountryEntity>(
      title: 'country'.tr(),
      items: countries
          .where((CountryEntity e) => e.isActive)
          .map((CountryEntity country) => DropdownMenuItem<CountryEntity>(
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
        debugPrint(
            '🔄 CountryDropdown onChanged - new value: ${value.displayName}');
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
