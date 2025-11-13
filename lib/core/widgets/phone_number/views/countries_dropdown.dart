import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../services/get_it.dart';
import '../../../usecase/usecase.dart';
import '../../../utilities/app_validators.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';
import '../../custom_dropdown.dart';
import '../../../sources/data_state.dart';

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
  List<CountryEntity> countries = [];
  CountryEntity? selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialValue;
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final GetCountiesUsecase getCountries = GetCountiesUsecase(locator());
    await LocalCountry().refresh();

    final DataState<List<CountryEntity>> result =
        await getCountries.call(const Duration(hours: 1));

    if (result is DataSuccess &&
        result.entity != null &&
        result.entity!.isNotEmpty) {
      countries = result.entity!;
    } else {
      countries = LocalCountry().activeCountries;
    }

    // If no initial country, default to Pakistan (if exists), else first active
    selectedCountry ??= _findPakistan(countries) ??
        countries.firstWhere(
          (e) => e.isActive,
          orElse: () => countries.first,
        );

    if (mounted) setState(() {});
  }

  CountryEntity? _findPakistan(List<CountryEntity> list) {
    for (final CountryEntity c in list) {
      final lower =
          (c.displayName + c.countryName + c.alpha2 + c.isoCode + c.countryCode)
              .toLowerCase()
              .replaceAll(' ', '');
      if (lower.contains('pakistan') ||
          lower.contains('pk') ||
          lower.contains('+92') ||
          c.countryCodes
              .any((code) => code.toLowerCase() == 'pk' || code == '+92')) {
        return c;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<CountryEntity> activeCountries =
        countries.where((e) => e.isActive).toList();
    final List<CountryEntity> sourceList =
        activeCountries.isEmpty ? countries : activeCountries;

    return CustomDropdown<CountryEntity>(
      title: 'Country',
      hint: '',
      searchBy: (DropdownMenuItem<CountryEntity> item) {
        final CountryEntity? country = item.value;
        return country?.displayName ?? '';
      },
      selectedItemBuilder: (CountryEntity? country) {
        if (country == null) return const SizedBox.shrink();
        return Row(
          children: [
            _CountryFlag(flag: country.flag),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                country.displayName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
      selectedItemPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      items: sourceList.map((country) {
        return DropdownMenuItem<CountryEntity>(
          value: country,
          child: Row(
            children: [
              _CountryFlag(flag: country.flag),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  country.displayName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      selectedItem: selectedCountry,
      onChanged: (CountryEntity? value) {
        if (value == null) return;
        setState(() => selectedCountry = value);
        widget.onChanged(value);
      },
      validator: (bool? val) => widget.validator != null
          ? widget.validator!(val)
          : AppValidator.requireSelection(val),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  const _CountryFlag({required this.flag});

  final String flag;

  @override
  Widget build(BuildContext context) {
    if (flag.isEmpty) {
      return Container(
        height: 16,
        width: 20,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 16,
        width: 20,
        child: SvgPicture.network(
          flag,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => const SizedBox(
            width: 20,
            height: 16,
            child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
          ),
        ),
      ),
    );
  }
}
