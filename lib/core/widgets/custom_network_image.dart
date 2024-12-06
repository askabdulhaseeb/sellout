import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loader.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.imageURL,
    this.placeholder = '/',
    this.fit = BoxFit.cover,
    this.timeLimit = const Duration(days: 2),
    this.size,
    super.key,
  });
  final String? imageURL;
  final String placeholder;
  final BoxFit? fit;
  final Duration? timeLimit;
  final double? size;

  @override
  Widget build(BuildContext context) {
    String placeholderText = placeholder.isEmpty
        ? '/'
        : placeholder.length > 1
            ? placeholder.substring(0, 2)
            : placeholder;
    return imageURL == null || (imageURL ?? '').isEmpty
        ? Container(
            height: size,
            width: size,
            color: Theme.of(context).dividerColor,
            alignment: Alignment.center,
            child: Text(
              placeholderText.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageURL ?? '',
            fit: fit,
            height: size,
            width: size,
            placeholder: (BuildContext context, String url) => Container(
              color: Theme.of(context).dividerColor,
              child: const Loader(),
            ),
            errorWidget: (BuildContext context, String url, _) => Text(
              placeholderText.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          );
  }
}
