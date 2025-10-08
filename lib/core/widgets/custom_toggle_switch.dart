import 'package:flutter/material.dart';

/// A generic custom toggle switch widget that supports:
/// - Multiple selectable labels
/// - Read-only mode
/// - Custom colors and border options
/// - Label heading text
/// - Dynamic selection state
class CustomToggleSwitch<T> extends StatelessWidget {
  const CustomToggleSwitch({
    required this.labels,
    required this.labelStrs,
    required this.labelText,
    required this.onToggle,
    this.initialValue,
    this.solidbgColor = false,
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

  /// Core configuration
  final List<T> labels;
  final List<String> labelStrs;
  final String labelText;
  final void Function(T)? onToggle;
  final T? initialValue;

  /// Appearance and styling
  final bool solidbgColor;
  final bool readOnly;
  final List<Color>? selectedColors;
  final bool isShaded;
  final double? containerHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final double horizontalMargin;
  final double verticalMargin;
  final double widgetMargin;

  /// Border and color behavior
  final Color? unseletedBorderColor;
  final Color? unseletedTextColor;
  final double borderWidth;
  final double borderRad;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRad);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: widgetMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (labelText.isNotEmpty) _buildLabelText(),
          _buildToggleRow(context, radius),
        ],
      ),
    );
  }

  // 🔹 Label Heading
  Widget _buildLabelText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        labelText,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  // 🔹 Row Builder
  Widget _buildToggleRow(BuildContext context, BorderRadius radius) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      child: Row(
        spacing: labels.length == 2 ? 16 : 4,
        children: List.generate(labels.length, (int index) {
          final T labelValue = labels[index];
          final bool isSelected = labelValue == initialValue;
          final Color selectedColor = _getSelectedColor(index, context);

          return Expanded(
            child: _ToggleButton<T>(
              text: labelStrs[index],
              isSelected: isSelected,
              color: selectedColor,
              readOnly: readOnly,
              solidbgColor: solidbgColor,
              isShaded: isShaded,
              containerHeight: containerHeight,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              borderRadius: radius,
              borderWidth: borderWidth,
              unselectedBorderColor: unseletedBorderColor,
              unselectedTextColor: unseletedTextColor,
              onTap: () => onToggle?.call(labelValue),
            ),
          );
        }),
      ),
    );
  }

  // 🔹 Helper to safely fetch color
  Color _getSelectedColor(int index, BuildContext context) {
    if (selectedColors != null && selectedColors!.length > index) {
      return selectedColors![index];
    }
    return Theme.of(context).primaryColor;
  }
}

/// A single toggle button tile used inside [CustomToggleSwitch].
class _ToggleButton<T> extends StatelessWidget {
  const _ToggleButton({
    required this.text,
    required this.isSelected,
    required this.color,
    required this.readOnly,
    required this.solidbgColor,
    required this.isShaded,
    required this.containerHeight,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.borderRadius,
    required this.borderWidth,
    required this.unselectedBorderColor,
    required this.unselectedTextColor,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final Color color;
  final bool readOnly;
  final bool solidbgColor;
  final bool isShaded;
  final double? containerHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color? unselectedBorderColor;
  final Color? unselectedTextColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = ColorScheme.of(context);

    // 🔹 Background color logic
    final Color bgColor = isSelected
        ? (solidbgColor
            ? color // full solid
            : color.withValues(alpha: isShaded ? 0.1 : 0))
        : scheme.outline.withValues(alpha: isShaded ? 0.1 : 0);

    // 🔹 Text color logic
    final Color textColor = isSelected
        ? (solidbgColor
            ? Colors.white // ensure visibility
            : color)
        : unselectedTextColor ?? scheme.outline;

    return InkWell(
      borderRadius: borderRadius,
      onTap: readOnly ? null : onTap,
      child: Container(
        height: containerHeight ?? 30,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: bgColor,
          border: Border.all(
            width: borderWidth,
            color: isSelected ? color : unselectedBorderColor ?? scheme.outline,
          ),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
