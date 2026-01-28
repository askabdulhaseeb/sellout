import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../services/get_it.dart';
import '../../../usecase/usecase.dart';
import '../../../utilities/app_validators.dart';
import '../../inputs/custom_textformfield.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';
import '../../../sources/data_state.dart';

class CountryDropdownField extends StatefulWidget {
  const CountryDropdownField({
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.allowedCountryCodes,
    super.key,
  });

  final CountryEntity? initialValue;
  final void Function(CountryEntity) onChanged;
  final String? Function(bool?)? validator;
  final List<String>? allowedCountryCodes;

  @override
  State<CountryDropdownField> createState() => _CountryDropdownFieldState();
}

class _CountryDropdownFieldState extends State<CountryDropdownField> {
  @override
  void didUpdateWidget(covariant CountryDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != selectedCountry) {
      setState(() {
        selectedCountry = widget.initialValue;
      });
      if (_controller != null) {
        Future<void>.microtask(() {
          if (mounted) {
            _controller!.text = selectedCountry?.displayName ?? '';
          }
        });
      }
    }
  }

  CountryEntity? selectedCountry;
  TextEditingController? _controller;
  late Future<List<CountryEntity>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialValue;
    _controller = TextEditingController(
      text: selectedCountry?.displayName ?? '',
    );
    _countriesFuture = _loadCountries();
  }

  Future<List<CountryEntity>> _loadCountries() async {
    final GetCountiesUsecase getCountries = GetCountiesUsecase(locator());
    await LocalCountry().refresh();
    final DataState<List<CountryEntity>> result = await getCountries.call(
      const Duration(hours: 1),
    );
    final List<CountryEntity>? remote = (result is DataSuccess)
        ? result.entity
        : null;
    final List<CountryEntity> countries = (remote != null && remote.isNotEmpty)
        ? remote
        : LocalCountry().activeCountries;

    List<CountryEntity> filtered = countries
        .where((CountryEntity e) => e.isActive)
        .toList();

    // Filter by allowed country codes if provided
    if (widget.allowedCountryCodes != null &&
        widget.allowedCountryCodes!.isNotEmpty) {
      filtered = filtered.where((CountryEntity country) {
        return widget.allowedCountryCodes!.contains(country.countryCode);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CountryEntity>>(
      future: _countriesFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<CountryEntity>> snapshot) {
            final List<CountryEntity> countries =
                snapshot.data ?? <CountryEntity>[];
            return TypeAheadField<CountryEntity>(
              suggestionsCallback: (String pattern) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return <CountryEntity>[];
                }
                if (snapshot.hasError || countries.isEmpty) {
                  return <CountryEntity>[];
                }
                if (pattern.isEmpty) return countries;
                return countries
                    .where(
                      (CountryEntity country) => country.displayName
                          .toLowerCase()
                          .contains(pattern.toLowerCase()),
                    )
                    .toList();
              },
              builder:
                  (
                    BuildContext context,
                    TextEditingController controller,
                    FocusNode focusNode,
                  ) {
                    _controller = controller;
                    // Always show selected country in field
                    if (selectedCountry != null &&
                        controller.text != selectedCountry!.displayName) {
                      controller.text = selectedCountry!.displayName;
                    }
                    return CustomTextFormField(
                      labelText: 'country'.tr(),
                      hint: 'country'.tr(),
                      controller: controller,
                      focusNode: focusNode,
                      validator: (String? value) => widget.validator != null
                          ? widget.validator!(selectedCountry != null)
                          : AppValidator.requireSelection(
                              selectedCountry != null,
                            ),
                      onTap: () {
                        focusNode.requestFocus();
                        controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: controller.text.length,
                        );
                      },
                    );
                  },
              itemBuilder: (BuildContext context, CountryEntity country) {
                return ListTile(
                  leading: _CountryFlag(flag: country.flag),
                  title: Text(
                    country.displayName,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
              onSelected: (CountryEntity country) {
                setState(() {
                  selectedCountry = country;
                });
                if (_controller != null) {
                  _controller!.text = country.displayName;
                  _controller!.selection = TextSelection.collapsed(
                    offset: _controller!.text.length,
                  );
                }
                widget.onChanged(country);
              },
              emptyBuilder: (BuildContext context) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No countries found'),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No countries found'),
                );
              },
            );
          },
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
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.3),
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
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                ),
              ),
            ),
          );
  }
}
