import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.imageURL,
    this.placeholder = '/',
    this.fit = BoxFit.cover,
    this.timeLimit = const Duration(days: 2),
    this.size,
    this.color,
    super.key,
  });

  final String? imageURL;
  final String placeholder;
  final BoxFit? fit;
  final Duration? timeLimit;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final String placeholderText = placeholder.isEmpty
        ? ''
        : placeholder.length > 1
        ? placeholder.substring(0, 2)
        : placeholder;

    if (imageURL == null || imageURL!.isEmpty) {
      return Container(
        height: size,
        width: size,
        color: color ?? Theme.of(context).dividerColor,
        alignment: Alignment.center,
        child: Text(
          placeholderText.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageURL!,
      fit: fit,
      height: size,
      width: size,
      placeholder: (_, _) => Container(
        height: size,
        width: size,
        color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
      ),
      errorWidget: (_, _, _) => Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        color: color ?? Theme.of(context).dividerColor,
        child: Text(
          placeholderText.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
