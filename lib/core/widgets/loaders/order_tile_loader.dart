import 'package:flutter/material.dart';

class OrderTileLoader extends StatelessWidget {
  const OrderTileLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).dividerColor;
    final BorderRadius radius = BorderRadius.circular(2);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image placeholder
          ClipRRect(
            borderRadius: radius,
            child: Container(
              height: 60,
              width: 60,
              color: baseColor,
            ),
          ),
          const SizedBox(width: 8),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildBox(height: 12, width: 60, color: baseColor),
                    const SizedBox(width: 6),
                    _buildBox(height: 10, width: 40, color: baseColor),
                  ],
                ),
                const SizedBox(height: 8),
                _buildBox(height: 12, width: double.infinity, color: baseColor),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    _buildBox(height: 12, width: 50, color: baseColor),
                    const SizedBox(width: 6),
                    _buildBox(height: 12, width: 40, color: baseColor),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Button placeholders
          SizedBox(
            width: 110,
            child: Column(
              children: <Widget>[
                _buildBox(
                  height: 28,
                  width: 80,
                  color: baseColor,
                  radius: BorderRadius.circular(20),
                ),
                const SizedBox(height: 8),
                _buildBox(
                  height: 28,
                  width: 80,
                  color: baseColor,
                  radius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox({
    required double height,
    required double width,
    required Color color,
    BorderRadius? radius,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius ?? BorderRadius.circular(4),
      ),
    );
  }
}
