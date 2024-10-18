import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularProfilePhoto extends StatelessWidget {
  const CircularProfilePhoto({
    required this.url,
    this.placeholder = '/',
    this.size = 24,
    super.key,
  });
  final String? url;
  final double size;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    String placeholderText = placeholder.isEmpty
        ? '/'
        : placeholder.length > 1
            ? placeholder.substring(0, 2)
            : placeholder;
    return CircleAvatar(
      radius: size,
      backgroundImage: url == null || (url?.isEmpty ?? true)
          ? null
          : CachedNetworkImageProvider(url!),
      child: url == null || (url?.isEmpty ?? true)
          ? Text(
              placeholderText.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          : null,
    );
  }
}
