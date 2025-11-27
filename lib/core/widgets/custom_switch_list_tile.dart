import 'package:flutter/material.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.loading = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w400))
          : null,
      trailing: CustomSwitch(
        value: value,
        onChanged: loading ? (_) {} : onChanged,
        loading: loading,
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.width = 36,
    this.height = 20,
    this.loading = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double width;
  final double height;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height),
            color: value
                ? (activeColor ?? colorScheme.secondary)
                : (inactiveColor ?? colorScheme.outline),
            boxShadow: value
                ? <BoxShadow>[
                    BoxShadow(
                      color: (activeColor ?? colorScheme.outline)
                          .withOpacity(0.25),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ]
                : <BoxShadow>[]),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              width: height * 0.8,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: thumbColor ??
                    (value
                        ? theme.scaffoldBackgroundColor
                        : colorScheme.surfaceContainerHighest),
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 1.2,
                    offset: const Offset(0, 0.4),
                  ),
                ],
              ),
            ),
            if (loading)
              SizedBox(
                width: height * 0.5,
                height: height * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
