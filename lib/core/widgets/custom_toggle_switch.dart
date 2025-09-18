import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomToggleSwitch<T> extends StatelessWidget {
  const CustomToggleSwitch({
    required this.labels,
    required this.labelStrs,
    required this.labelText,
    required this.onToggle,
    this.initialValue,
    this.readOnly = false,
    this.selectedColors,
    this.isShaded = true,
    this.containerHeight,
    this.verticalPadding = 4,
    this.horizontalPadding = 4,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
    this.unseletedBorderColor,
    this.unseletedTextColor,
    this.borderWidth = 1,
    this.borderRad = 8,
    this.widgetMargin = 4,
    super.key,
  });
  final List<T> labels;
  final bool readOnly;
  final T? initialValue;
  final String labelText;
  final List<String> labelStrs;
  final void Function(T)? onToggle;
  final List<Color>? selectedColors;
  final bool isShaded;
  final double? containerHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final double horizontalMargin;
  final double verticalMargin;
  final double widgetMargin;

  final Color? unseletedBorderColor;
  final Color? unseletedTextColor;
  final double borderWidth;
  final double borderRad;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(borderRad);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widgetMargin),
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: verticalMargin, horizontal: horizontalMargin),
            child: Row(
              spacing: labels.length == 2 ? 16 : 4,
              children: labelStrs.map(
                (String e) {
                  final int index = labels.contains(initialValue)
                      ? labels.indexWhere((T e2) => e2 == initialValue)
                      : -1;
                  final int currentIndex = labelStrs.indexOf(e);
                  final bool isSelected = index == currentIndex;
                  final Color selectedColor = (selectedColors != null &&
                          selectedColors!.length > currentIndex)
                      ? selectedColors![currentIndex]
                      : AppTheme.primaryColor;
                  return Expanded(
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: readOnly
                          ? null
                          : () => onToggle?.call(labels[currentIndex]),
                      child: Container(
                        height: containerHeight ?? 30,
                        padding: EdgeInsets.symmetric(
                          vertical: verticalPadding,
                          horizontal: horizontalPadding,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: isSelected
                              ? selectedColor.withValues(
                                  alpha: isShaded ? 0.1 : 0.0)
                              : ColorScheme.of(context)
                                  .outline
                                  .withValues(alpha: isShaded ? 0.1 : 0),
                          border: Border.all(
                            width: borderWidth,
                            color: borderWidth == 0
                                ? Colors.transparent
                                : isSelected
                                    ? selectedColor
                                    : unseletedBorderColor ??
                                        ColorScheme.of(context).outline,
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            e,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // fontSize: seletedFontSize,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? selectedColor
                                  : unseletedTextColor ??
                                      ColorScheme.of(context).outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
