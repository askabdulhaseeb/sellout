import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../services/get_it.dart';
import '../../../sources/api_call.dart';
import '../../inputs/custom_textformfield.dart' show CustomTextFormField;
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';

class CountryTypeAheadField extends StatefulWidget {
  const CountryTypeAheadField({
    required this.selectedCountry,
    required this.onChanged,
    super.key,
  });

  final CountryEntity? selectedCountry;
  final void Function(CountryEntity?) onChanged;

  @override
  State<CountryTypeAheadField> createState() => _CountryTypeAheadFieldState();
}

class _CountryTypeAheadFieldState extends State<CountryTypeAheadField> {
  late final TextEditingController _controller;
  List<CountryEntity> _countries = <CountryEntity>[];
  bool _isLoading = true;
  bool _didSetInitial = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCountries();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didSetInitial && mounted) {
        _controller.text = widget.selectedCountry?.countryCode ?? '';
        _didSetInitial = true;
      }
    });
  }

  Future<void> _loadCountries() async {
    try {
      final GetCountiesUsecase getCountries = GetCountiesUsecase(locator());
      final DataState<List<CountryEntity>> result = await getCountries.call(
        const Duration(hours: 1),
      );

      List<CountryEntity> countries = <CountryEntity>[];
      if (result is DataSuccess<List<CountryEntity>>) {
        countries = result.entity ?? <CountryEntity>[];
      }

      // Fallback to local if remote is empty
      if (countries.isEmpty) {
        countries = LocalCountry().activeCountries;
      }

      if (mounted) {
        setState(() {
          _countries = countries;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _countries = LocalCountry().activeCountries;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant CountryTypeAheadField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCountry?.countryCode !=
        oldWidget.selectedCountry?.countryCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.selectedCountry?.countryCode ?? '';
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<CountryEntity>(
      suggestionsCallback: (String pattern) {
        if (_isLoading) return <CountryEntity>[];
        if (pattern.trim().isEmpty) return _countries;
        return _countries
            .where(
              (CountryEntity c) =>
                  c.displayName.toLowerCase().contains(pattern.toLowerCase()) ||
                  c.countryCode.toLowerCase().contains(pattern.toLowerCase()),
            )
            .toList();
      },
      builder:
          (
            BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
          ) {
            return CustomTextFormField(
              hint: 'country'.tr(),
              controller: _controller,
              focusNode: focusNode,
              readOnly: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            );
          },
      itemBuilder: (BuildContext context, CountryEntity suggestion) {
        return Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              if (suggestion.flag.isNotEmpty)
                SizedBox(
                  height: 16,
                  width: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SvgPicture.network(
                      suggestion.flag,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  suggestion.countryCode,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemSeparatorBuilder: (BuildContext context, int index) =>
          const Divider(endIndent: 4, indent: 4),
      onSelected: (CountryEntity suggestion) {
        if (mounted) {
          setState(() {
            _controller.text = suggestion.countryCode;
          });
        }
        widget.onChanged(suggestion);
      },
    );
  }
}
