import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../../custom_textformfield.dart';

class CountryTypeAheadField extends StatelessWidget {
  const CountryTypeAheadField({
    required this.selectedCountry,
    required this.onChanged,
    super.key,
  });
  final CountryEntity? selectedCountry;
  final void Function(CountryEntity?) onChanged;
  @override
  Widget build(BuildContext context) {
    final List<CountryEntity> countries = LocalCountry().activeCountries;
    return TypeAheadField<CountryEntity>(
      suggestionsCallback: (String pattern) {
        if (pattern.isEmpty) return countries;
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
            if (selectedCountry != null &&
                controller.text != selectedCountry!.countryCode) {
              controller.text = selectedCountry!.countryCode;
            }
            return CustomTextFormField(
              hint: 'country'.tr(),
              controller: controller,
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
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
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
              const SizedBox(width: 4),
              Text(
                suggestion.countryCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
      onSelected: (CountryEntity suggestion) {
        onChanged(suggestion);
      },
    );
  }
}
