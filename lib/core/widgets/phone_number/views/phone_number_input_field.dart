import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../services/get_it.dart';
import '../../../usecase/usecase.dart';
import '../../../utilities/app_validators.dart';
import '../../custom_textformfield.dart';
import '../../custom_dropdown.dart';
import '../data/sources/local_country.dart';
import '../domain/entities/country_entity.dart';
import '../domain/entities/phone_number_entity.dart';
import '../domain/usecase/get_counties_usecase.dart';

class PhoneNumberInputField extends StatefulWidget {
  const PhoneNumberInputField({
    required this.onChange,
    this.initialValue,
    this.labelText = '',
    super.key,
  });
  final String labelText;
  final PhoneNumberEntity? initialValue;
  final void Function(PhoneNumberEntity) onChange;
  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  final TextEditingController controller = TextEditingController();
  List<CountryEntity> countries = <CountryEntity>[];
  CountryEntity? selectedCountry;
  GetCountiesUsecase? getCountiesUsecase;

  int? _maxLocalDigits() {
    final CountryEntity? c = selectedCountry;
    if (c == null) return null;
    final dynamic nfRaw = c.numberFormat;
    final Map<String, String> parsed = _parseNumberFormat(nfRaw);
    final String display = parsed['format'] ??
        (nfRaw is String ? nfRaw : (nfRaw?.toString() ?? ''));
    if (display.isEmpty) return null;
    // count X or x
    final int xCount =
        display.split('').where((s) => s == 'X' || s == 'x').length;
    if (xCount > 0) return xCount;

    // fallback: try to find \d{n} or {n}
    try {
      final RegExp r1 = RegExp(r'\\d\{(\d+)\}');
      final Match? m1 = r1.firstMatch(parsed['regex'] ?? display);
      if (m1 != null) return int.tryParse(m1.group(1) ?? '');
      final RegExp r2 = RegExp(r'\{(\d+)\}');
      final Match? m2 = r2.firstMatch(parsed['regex'] ?? display);
      if (m2 != null) return int.tryParse(m2.group(1) ?? '');
    } catch (_) {}
    return null;
  }

  Map<String, String> _parseNumberFormat(dynamic nf) {
    final Map<String, String> result = <String, String>{};
    if (nf == null) return result;
    try {
      // If it's already a NumberFormatEntity
      if (nf is NumberFormatEntity) {
        if ((nf.format).isNotEmpty) result['format'] = nf.format;
        if ((nf.regex).isNotEmpty) result['regex'] = nf.regex;
        return result;
      }

      // If it's a Map-like object
      if (nf is Map) {
        if (nf['format'] is String) result['format'] = nf['format'];
        if (nf['regex'] is String) result['regex'] = nf['regex'];
        return result;
      }

      // Otherwise treat as string
      final String s = nf.toString();
      if (s.isEmpty) return result;
      try {
        final RegExp reFormat = RegExp(r'format:\s*([^,}]+)');
        final Match? mFormat = reFormat.firstMatch(s);
        if (mFormat != null) result['format'] = mFormat.group(1)!.trim();
        final RegExp reRegex = RegExp(r'regex:\s*([^,}]+)');
        final Match? mRegex = reRegex.firstMatch(s);
        if (mRegex != null) result['regex'] = mRegex.group(1)!.trim();
      } catch (_) {}

      if (result.isEmpty) {
        try {
          final String candidate = s.replaceAll("'", '"');
          final dynamic dec = jsonDecode(candidate);
          if (dec is Map) {
            if (dec['format'] is String) result['format'] = dec['format'];
            if (dec['regex'] is String) result['regex'] = dec['regex'];
          } else {
            // fallback: use whole string as display
            result['format'] = s;
          }
        } catch (_) {
          result['format'] = s;
        }
      }
    } catch (_) {}
    return result;
  }

  String _buildRegexFromDisplay(String display) {
    if (display.isEmpty) return '';
    final StringBuffer sb = StringBuffer();
    int i = 0;
    while (i < display.length) {
      final String ch = display[i];
      if (ch == 'X' || ch == 'x') {
        int run = 1;
        i++;
        while (i < display.length && (display[i] == 'X' || display[i] == 'x')) {
          run++;
          i++;
        }
        sb.write('\\d{' + run.toString() + '}');
        continue;
      }
      if (RegExp(r'\d').hasMatch(ch)) {
        sb.write(ch);
        i++;
        continue;
      }
      if (ch == '+') {
        sb.write('\\+');
        i++;
        continue;
      }
      if (ch == ' ' || ch == '-' || ch == '(' || ch == ')' || ch == '.') {
        i++;
        continue;
      }
      sb.write(RegExp.escape(ch));
      i++;
    }
    return '^' + sb.toString() + r'$';
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _postInit() {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue?.number ?? '';
      final String code = widget.initialValue?.countryCode ?? '';
      CountryEntity? c = LocalCountry().country(code);
      if (c != null && countries.contains(c)) {
        setState(() {
          selectedCountry = c;
        });
      } else {
        final int index = countries.indexWhere((CountryEntity e) {
          if (e.countryCode == code) {
            selectedCountry = e;
            return true;
          }
          return false;
        });
        if (index != -1) {
          setState(() {
            selectedCountry = countries[index];
          });
        }
      }
    }
  }

  Future<void> _init() async {
    getCountiesUsecase = GetCountiesUsecase(locator());
    await LocalCountry().refresh();
    await countiries();
    if (!mounted) return; // ✅ check before calling setState
    _postInit();
  }

  Future<void> countiries() async {
    DataState<List<CountryEntity>> cou =
        await getCountiesUsecase!.call(const Duration(days: 1));
    if (cou is DataSuccess) {
      countries = cou.entity ?? LocalCountry().activeCountries;
    }
    if (!mounted) return; // ✅ check before calling setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              widget.labelText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomDropdown<CountryEntity>(
              title: '',
              hint: '',
              width: 125,
              items: countries
                  .where((CountryEntity e) => e.isActive)
                  .map((CountryEntity e) {
                return DropdownMenuItem<CountryEntity>(
                  value: e,
                  child: Text(e.countryCode,
                      style: TextTheme.of(context).bodyMedium),
                );
              }).toList(),
              selectedItem: selectedCountry,
              onChanged: (CountryEntity? value) {
                if (value == null) return;
                setState(() {
                  selectedCountry = value;
                  widget.onChange(PhoneNumberEntity(
                    countryCode: value.countryCode,
                    number: controller.text,
                  ));
                });
              },
              validator: (bool? val) => AppValidator.requireSelection(val),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: CustomTextFormField(
                controller: controller,
                readOnly: selectedCountry == null,
                onChanged: (String p0) => widget.onChange(PhoneNumberEntity(
                  countryCode: selectedCountry?.countryCode ?? '',
                  number: p0,
                )),
                keyboardType: TextInputType.number,
                maxLength: _maxLocalDigits(),
                validator: (String? value) {
                  final dynamic rawNf = selectedCountry?.numberFormat;
                  final Map<String, String> p = _parseNumberFormat(rawNf);
                  final String displayFormat = p['format'] ??
                      (rawNf is String ? rawNf : (rawNf?.toString() ?? ''));
                  String pattern = p['regex'] ?? '';
                  if (pattern.isEmpty) {
                    pattern = _buildRegexFromDisplay(displayFormat);
                  }
                  debugPrint(
                      '[PhoneNumberInputField] validating using pattern="$pattern" for full="${selectedCountry?.countryCode}$value" (display="$displayFormat")');
                  // Provide a human-friendly message showing the expected format
                  final String message = 'Use format: $displayFormat';
                  return AppValidator.customRegExp(
                      pattern, '${selectedCountry?.countryCode}$value',
                      message: message);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
