import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';

class MessageBgWidget extends StatelessWidget {
  const MessageBgWidget({
    required this.isMe,
    required this.child,
    this.height,
    this.color,
    super.key,
  });
  final bool isMe;
  final Widget child;
  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        constraints: BoxConstraints(maxWidth: size.width * 0.8, minWidth: 20),
        decoration: BoxDecoration(
          color:
              color ??
              (isMe
                  ? Theme.of(context).scaffoldBackgroundColor
                  : AppColors.lightPrimaryColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      ),
    );
  }
}
