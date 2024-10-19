import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loader.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.imageURL,
    this.placeholder = '/',
    this.fit = BoxFit.cover,
    this.timeLimit = const Duration(days: 2),
    super.key,
  });
  final String imageURL;
  final String placeholder;
  final BoxFit? fit;
  final Duration? timeLimit;

  @override
  Widget build(BuildContext context) {
    String placeholderText = placeholder.isEmpty
        ? '/'
        : placeholder.length > 1
            ? placeholder.substring(0, 2)
            : placeholder;
    return CachedNetworkImage(
      imageUrl: imageURL,
      fit: fit,
      placeholder: (BuildContext context, String url) => const Loader(),
      errorWidget: (BuildContext context, String url, _) => Text(
        placeholderText.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
