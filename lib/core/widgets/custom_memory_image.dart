import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../helper_functions/name_initials_helper.dart';

class CustomMemoryImage extends StatelessWidget {
  const CustomMemoryImage({
    required this.displayName,
    super.key,
    this.photo,
    this.size = 40.0,
    this.color,
    this.fit = BoxFit.cover,
    this.textStyle,
    this.showLoader = true,
  });

  final String displayName;
  final Uint8List? photo;
  final double size;
  final Color? color;
  final BoxFit fit;
  final TextStyle? textStyle;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        color ?? Theme.of(context).colorScheme.outline;
    final TextStyle initialsStyle = textStyle ??
        Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    if (photo != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.2),
          color: backgroundColor.withOpacity(0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.2),
          child: Image.memory(
            photo!,
            fit: fit,
            width: size,
            height: size,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) {
              return _buildInitials(backgroundColor, initialsStyle);
            },
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) {
              if (showLoader && frame == null) {
                return Center(
                  child: SizedBox(
                    width: size * 0.4,
                    height: size * 0.4,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              }
              return child;
            },
          ),
        ),
      );
    } else {
      return _buildInitials(backgroundColor, initialsStyle);
    }
  }

  Widget _buildInitials(Color backgroundColor, TextStyle initialsStyle) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      alignment: Alignment.center,
      child: Text(
        GetInitialsHelper.getInitials(displayName),
        style: initialsStyle,
      ),
    );
  }
}
