import 'package:flutter/material.dart';
import '../constants/app_spacings.dart';

class CustomExpandableTile extends StatefulWidget {
  const CustomExpandableTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.options = const <Map<String, dynamic>>[],
    this.content,
    this.onOptionSelected,
    this.initiallyExpanded = false,
    this.isExpanded,
    this.onExpansionChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Map<String, dynamic>> options;
  final Widget? content;
  final void Function(Map<String, dynamic>)? onOptionSelected;
  final bool initiallyExpanded;
  final bool? isExpanded;
  final void Function(bool)? onExpansionChanged;

  @override
  State<CustomExpandableTile> createState() => _CustomExpandableTileState();
}

class _CustomExpandableTileState extends State<CustomExpandableTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late String? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded ?? widget.initiallyExpanded;
    _selectedOptionId = null;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    final bool newValue = !_isExpanded;
    // Update locally for immediate visual feedback
    setState(() => _isExpanded = newValue);
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    // Notify parent to coordinate one-at-a-time expansion
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(newValue);
    }
  }

  void _selectOption(Map<String, dynamic> option) {
    setState(() => _selectedOptionId = option['id'] as String?);
    widget.onOptionSelected?.call(option);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool hasSelection = _selectedOptionId != null;
    final Color selectedColor = scheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: hasSelection
            ? selectedColor.withValues(alpha: 0.05)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: scheme.outline.withAlpha(128)),
        ),
      ),
      child: Row(
        children: <Widget>[
          if (hasSelection)
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusSm),
                  bottomLeft: Radius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(widget.icon, color: scheme.primary, size: 24),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.title,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.subtitle,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          RotationTransition(
                            turns: Tween<double>(
                              begin: 0,
                              end: 0.5,
                            ).animate(_animationController),
                            child: Icon(
                              Icons.expand_more,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (_isExpanded) ...<Widget>[
                        const SizedBox(height: AppSpacing.md),
                        if (widget.content != null)
                          widget.content!
                        else if (widget.options.isNotEmpty)
                          Column(
                            children: widget.options.map((
                              Map<String, dynamic> opt,
                            ) {
                              final String? optionId = opt['id'] as String?;
                              final bool isSelected =
                                  _selectedOptionId == optionId;
                              final String label =
                                  opt['label'] as String? ?? '';
                              final String? note = opt['note'] as String?;
                              final Color optionSelectedColor = scheme.primary;
                              return Container(
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.vSm,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? optionSelectedColor.withValues(
                                          alpha: 0.06,
                                        )
                                      : scheme.surface,
                                  border: Border.all(
                                    color: isSelected
                                        ? optionSelectedColor
                                        : scheme.outline,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSm,
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    if (isSelected)
                                      Container(
                                        width: 4,
                                        decoration: BoxDecoration(
                                          color: optionSelectedColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(
                                              AppSpacing.radiusSm,
                                            ),
                                            bottomLeft: Radius.circular(
                                              AppSpacing.radiusSm,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusSm,
                                          ),
                                          onTap: () => _selectOption(opt),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                              AppSpacing.sm,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: AppSpacing.vSm,
                                                        right: AppSpacing.sm,
                                                      ),
                                                  child: Icon(
                                                    isSelected
                                                        ? Icons
                                                              .radio_button_checked
                                                        : Icons
                                                              .radio_button_off,
                                                    size: 20,
                                                    color: isSelected
                                                        ? optionSelectedColor
                                                        : scheme
                                                              .onSurfaceVariant,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        label,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      if (note != null &&
                                                          note.isNotEmpty)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: AppSpacing
                                                                    .vXs,
                                                              ),
                                                          child: Text(
                                                            note,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  color: scheme
                                                                      .onSurfaceVariant,
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
