import 'dart:ui';
import 'package:flutter/material.dart';
import 'shadow_container.dart';

class ComingSoonOverlay extends StatelessWidget {
  const ComingSoonOverlay({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: colorScheme.surface.withValues(alpha: 0.2),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
              ),
            ),
          ),

          // Actual card with content
          ShadowContainer(
            borderRadius: BorderRadius.circular(12),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Icon with circular background
                ShadowContainer(
                  borderRadius: BorderRadius.circular(100),
                  padding: const EdgeInsets.all(20),
                  child: Icon(icon, size: 50, color: colorScheme.primary),
                ),
                const SizedBox(height: 28),

                // Title text
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle text
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
