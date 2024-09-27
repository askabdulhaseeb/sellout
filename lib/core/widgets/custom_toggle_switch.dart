import 'package:flutter/material.dart';

class CustomToggleSwitch<T> extends StatelessWidget {
  const CustomToggleSwitch({
    required this.labels,
    required this.labelStrs,
    required this.labelText,
    required this.onToggle,
    this.customWidths,
    this.initialValue,
    this.readOnly = false,
    super.key,
  });
  final List<T> labels;
  final bool readOnly;
  final T? initialValue;
  final String labelText;
  final List<String> labelStrs;
  final List<double>? customWidths;
  final void Function(T)? onToggle;

  @override
  Widget build(BuildContext context) {
    final double minWidth = MediaQuery.of(context).size.width - 52;
    final BorderRadius borderRadius = BorderRadius.circular(8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            labelText,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Wrap(
            spacing: labels.length == 2 ? 16 : 8,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            children: labelStrs.map(
              (String e) {
                final int index = labels.contains(initialValue)
                    ? labels.indexWhere((T e2) => e2 == initialValue)
                    : 0;
                final int currentIndex = labelStrs.indexOf(e);
                bool isSelected = index == currentIndex;
                return InkWell(
                  borderRadius: borderRadius,
                  onTap: () => onToggle!(labels[currentIndex]),
                  child: Container(
                    width: minWidth / labelStrs.length,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.05)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
