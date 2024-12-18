import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InDevMode extends StatelessWidget {
  const InDevMode({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return kDebugMode
        ? Opacity(
            opacity: 0.5,
            child: child,
          )
        : const SizedBox();
  }
}
