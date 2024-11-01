import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loader.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    required this.url,
    this.isCircle = false,
    this.placeholder = '/',
    this.size = 24,
    super.key,
  });
  final String? url;
  final bool isCircle;
  final double size;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    String placeholderText = placeholder.isEmpty
        ? '/'
        : placeholder.length > 1
            ? placeholder.substring(0, 2)
            : placeholder;
    return isCircle
        ? CircleAvatar(
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
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (url ?? '').startsWith('https://') ||
                    (url ?? '').startsWith('http://')
                ? CachedNetworkImage(
                    imageUrl: url ?? '',
                    height: size * 2,
                    width: size * 2,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) =>
                        const Loader(),
                    errorWidget:
                        (BuildContext context, String url, Object error) =>
                            placeholderWidget(context, placeholderText),
                  )
                : placeholderWidget(context, placeholderText),
          );
  }

  Widget placeholderWidget(BuildContext context, String placeholderText) {
    return Container(
      height: size * 2,
      width: size * 2,
      color: Theme.of(context).dividerColor,
      alignment: Alignment.center,
      child: Text(
        placeholderText.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
