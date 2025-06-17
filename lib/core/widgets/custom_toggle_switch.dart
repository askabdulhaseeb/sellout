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
    this.selectedColors,
    this.isShaded = true,
    this.seletedFontSize = 14,
    super.key,
  });

  final List<T> labels;
  final bool readOnly;
  final T? initialValue;
  final String labelText;
  final List<String> labelStrs;
  final List<double>? customWidths;
  final void Function(T)? onToggle;
  final List<Color>? selectedColors; // 🌟 NEW ADDED for Order section
  final bool isShaded;
  final double seletedFontSize;
  @override
  Widget build(BuildContext context) {
    final double minWidth = MediaQuery.of(context).size.width - 52;
    final BorderRadius borderRadius = BorderRadius.circular(8);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (labelText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                labelText,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          Wrap(
            spacing: labels.length == 2 ? 16 : 4,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            children: labelStrs.map(
              (String e) {
                final int index = labels.contains(initialValue)
                    ? labels.indexWhere((T e2) => e2 == initialValue)
                    : -1;
                final int currentIndex = labelStrs.indexOf(e);
                final bool isSelected = index == currentIndex;

                // 🌟 Get the color for this button if selected
                final Color selectedColor = (selectedColors != null &&
                        selectedColors!.length > currentIndex)
                    ? selectedColors![currentIndex]
                    : Theme.of(context).primaryColor;

                return InkWell(
                  borderRadius: borderRadius,
                  onTap: readOnly
                      ? null
                      : () => onToggle?.call(labels[currentIndex]),
                  child: Container(
                    width: minWidth / labelStrs.length,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: isSelected
                          ? selectedColor.withValues(alpha: isShaded ? 0.1 : 0)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? selectedColor : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        e,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: seletedFontSize,
                          color: isSelected ? selectedColor : Colors.grey,
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
