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
  List<CountryEntity> countries = <CountryEntity>[];
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

    final List<CountryEntity>? remote =
        (result is DataSuccess) ? result.entity : null;
    countries = (remote != null && remote.isNotEmpty)
        ? remote
        : LocalCountry().activeCountries;

    selectedCountry ??= countries
            .where((CountryEntity e) => e.isActive)
            .firstWhereOrNull((_) => true) ??
        (countries.isNotEmpty ? countries.first : null);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<CountryEntity> activeCountries =
        countries.where((CountryEntity e) => e.isActive).toList();
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
          children: <Widget>[
            _CountryFlag(flag: country.flag),
            const SizedBox(width: 8),
            Text(
              country.displayName,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
      selectedItemPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      items: sourceList.map((CountryEntity country) {
        return DropdownMenuItem<CountryEntity>(
          value: country,
          child: Row(
            children: <Widget>[
              _CountryFlag(flag: country.flag),
              const SizedBox(width: 8),
              Text(
                country.displayName,
                overflow: TextOverflow.ellipsis,
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
    return flag.isEmpty
        ? Container(
            height: 16,
            width: 20,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        : ClipRRect(
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
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 1)),
                ),
              ),
            ),
          );
  }
}

extension _FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) => fold<T?>(
      null, (T? prev, T element) => prev ?? (test(element) ? element : null));
}
