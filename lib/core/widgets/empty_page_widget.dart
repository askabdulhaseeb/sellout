import 'package:flutter/material.dart';

class EmptyPageWidget extends StatefulWidget {
  const EmptyPageWidget({
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.childBelow,
    super.key,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Widget? childBelow;

  @override
  State<EmptyPageWidget> createState() => _EmptyPageWidgetState();
}

class _EmptyPageWidgetState extends State<EmptyPageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Animate from 0 → 1 once when created
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        widget.backgroundColor ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 20, width: double.infinity),
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor.withValues(alpha: 0.15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: baseColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? baseColor,
                size: 40,
              ),
            ),
          ),
        ),
        if (widget.childBelow != null) ...<Widget>[
          const SizedBox(height: 12),
          widget.childBelow!,
        ],
      ],
    );
  }
}
