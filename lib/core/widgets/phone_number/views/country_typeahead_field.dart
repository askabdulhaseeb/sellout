import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../../custom_textformfield.dart';

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
  bool _didSetInitial = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didSetInitial && mounted) {
        _controller.text = widget.selectedCountry?.countryCode ?? '';
        _didSetInitial = true;
      }
    });
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
    final List<CountryEntity> countries = LocalCountry().activeCountries;

    return TypeAheadField<CountryEntity>(
      suggestionsCallback: (String pattern) {
        if (pattern.trim().isEmpty) return countries;

        return countries
            .where(
              (CountryEntity c) =>
                  c.displayName.toLowerCase().contains(pattern.toLowerCase()) ||
                  c.countryCode.contains(pattern),
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
              controller: _controller, // ✅ Your controlled controller
              focusNode: focusNode,
              readOnly: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              borderRadius: 12,
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
                  maxLines: 1,
                  suggestion.countryCode,
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
        setState(() {
          _controller.text = suggestion.countryCode;
        });
        widget.onChanged(suggestion);
      },
    );
  }
}
