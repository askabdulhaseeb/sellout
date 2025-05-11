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
    super.key,
  });

  final String? initialValue;
  final void Function(String) onChanged;

  @override
  State<CountryDropdownField> createState() => _CountryDropdownFieldState();
}

class _CountryDropdownFieldState extends State<CountryDropdownField> {
  List<CountryEntity> countries = <CountryEntity>[];
  String? selectedCountry;
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
        countries
            .any((CountryEntity e) => e.displayName == widget.initialValue)) {
      selectedCountry = widget.initialValue;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      title: 'country'.tr(),
      items: countries
          .where((CountryEntity e) => e.isActive)
          .map((CountryEntity country) => DropdownMenuItem<String>(
                value: country.displayName,
                child: Text(country.displayName),
              ))
          .toList(),
      selectedItem: selectedCountry,
      onChanged: (String? value) {
        if (value == null) return;
        setState(() {
          selectedCountry = value;
          widget.onChanged(value); // This will notify the parent
        });
      },
      validator: (_) => null,
    );
  }
}
