import 'package:flutter/material.dart';

class BalanceSkeleton extends StatelessWidget {
  const BalanceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    skeletonBox(width: 32, height: 32),
                    const SizedBox(width: 8),
                    skeletonBox(width: 120, height: 18),
                  ],
                ),
                const SizedBox(height: 8),
                skeletonBox(width: 100, height: 32),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    skeletonBox(width: 60, height: 14),
                    const SizedBox(width: 8),
                    skeletonBox(width: 60, height: 14),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    skeletonBox(width: 80, height: 14),
                    skeletonBox(width: 80, height: 14),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    skeletonBox(width: 60, height: 32),
                    skeletonBox(width: 60, height: 32),
                    skeletonBox(width: 60, height: 32),
                    skeletonBox(width: 60, height: 32),
                  ],
                ),
                const SizedBox(height: 16),
                skeletonBox(width: double.infinity, height: 40),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    skeletonBox(width: 16, height: 16),
                    const SizedBox(width: 4),
                    skeletonBox(width: 200, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget skeletonBox({double width = 80, double height = 16}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
