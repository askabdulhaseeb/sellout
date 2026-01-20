import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../constants/app_spacings.dart';
import 'package_details_widget.dart';

/// Card widget for a single parcel option
/// Can be expanded/collapsed to show custom fields if needed
class ParcelOptionCard extends StatefulWidget {
  const ParcelOptionCard({
    required this.parcel,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final ParcelOption parcel;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  State<ParcelOptionCard> createState() => _ParcelOptionCardState();
}

class _ParcelOptionCardState extends State<ParcelOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  bool _isExpanded = false;

  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (widget.parcel.id == 'custom') {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _expandController.forward();
        } else {
          _expandController.reverse();
        }
      });
    } else {
      widget.onSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandController,
      builder: (BuildContext context, Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Material(
              child: InkWell(
                onTap: _toggleExpand,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: widget.isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        widget.parcel.icon,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              widget.parcel.label.tr(),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.parcel.dimensions.tr(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.parcel.id == 'custom')
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        )
                      else
                        Radio<bool>(
                          value: true,
                          groupValue: widget.isSelected,
                          onChanged: (_) => widget.onSelected(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.parcel.id == 'custom')
              SizeTransition(
                sizeFactor: _expandController,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Column(
                    children: <Widget>[
                      Row(
                        spacing: AppSpacing.sm,
                        children: <Widget>[
                          Expanded(
                            child: _CustomDimensionField(
                              label: 'weight_kg'.tr(),
                              controller: _weightController,
                            ),
                          ),
                          const Text('or'),
                          Expanded(
                            child: _CustomDimensionField(
                              label: 'length_cm'.tr(),
                              controller: _lengthController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        spacing: AppSpacing.sm,
                        children: <Widget>[
                          Expanded(
                            child: _CustomDimensionField(
                              label: 'width_cm'.tr(),
                              controller: _widthController,
                            ),
                          ),
                          Expanded(
                            child: _CustomDimensionField(
                              label: 'height_cm'.tr(),
                              controller: _heightController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Text field for custom dimension input
class _CustomDimensionField extends StatelessWidget {
  const _CustomDimensionField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
