import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/custom_dropdown.dart';

class CustomYearDropdown extends StatefulWidget {
  const CustomYearDropdown({
    required this.selectedYear,
    required this.onChanged,
    super.key,
    this.title = '',
    this.hintText,
    this.startYear = 1990,
  });
  final String? selectedYear;
  final ValueChanged<String?> onChanged;
  final String title;
  final String? hintText;
  final int startYear;

  @override
  State<CustomYearDropdown> createState() => _CustomYearDropdownState();
}

class _CustomYearDropdownState extends State<CustomYearDropdown> {
  late List<String> _yearList;

  @override
  void initState() {
    super.initState();
    _generateYearList();
  }

  void _generateYearList() {
    final int currentYear = DateTime.now().year;
    _yearList = List.generate(
      currentYear - widget.startYear + 1,
      (int index) => (currentYear - index).toString(), // Descending order
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
        title: widget.title,
        selectedItem: widget.selectedYear,
        hint: widget.hintText,
        items: _yearList
            .map((String year) => DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                ))
            .toList(),
        onChanged: widget.onChanged,
        validator: (bool? value) => null);
  }
}
