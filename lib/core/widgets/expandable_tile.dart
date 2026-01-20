import 'package:flutter/material.dart';
import '../constants/app_spacings.dart';

class CustomExpandableTile extends StatefulWidget {
  const CustomExpandableTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.options,
    this.onOptionSelected,
    this.initiallyExpanded = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Map<String, dynamic>> options;
  final void Function(Map<String, dynamic>)? onOptionSelected;
  final bool initiallyExpanded;

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
    _isExpanded = widget.initiallyExpanded;
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
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _selectOption(Map<String, dynamic> option) {
    setState(() => _selectedOptionId = option['id'] as String?);
    widget.onOptionSelected?.call(option);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: scheme.outline.withAlpha(128)),
        ),
      ),
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
                                ?.copyWith(color: scheme.onSurfaceVariant),
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
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: widget.options.map((Map<String, dynamic> option) {
                      final String? optionId = option['id'] as String?;
                      final bool isSelected = _selectedOptionId == optionId;
                      return FilterChip(
                        label: Text(option['label'] as String? ?? ''),
                        selected: isSelected,
                        onSelected: (_) => _selectOption(option),
                        backgroundColor: Colors.transparent,
                        selectedColor: scheme.primary.withValues(alpha: 0.12),
                        side: BorderSide(
                          color: isSelected ? scheme.primary : scheme.outline,
                          width: isSelected ? 2 : 1,
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
    );
  }
}
