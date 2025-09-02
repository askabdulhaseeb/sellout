import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    final String placeholderText = placeholder.isEmpty
        ? '/'
        : placeholder.length > 1
            ? placeholder.substring(0, 2)
            : placeholder;

    final bool isValidUrl = url != null &&
        (url!.startsWith('http://') || url!.startsWith('https://'));

    if (isCircle) {
      return CircleAvatar(
        radius: size,
        backgroundImage: isValidUrl ? CachedNetworkImageProvider(url!) : null,
        backgroundColor: Theme.of(context).dividerColor,
        child: !isValidUrl
            ? Text(
                placeholderText.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            : null,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isValidUrl
          ? CachedNetworkImage(
              imageUrl: url!,
              height: size * 2,
              width: size * 2,
              fit: BoxFit.cover,
              placeholder: (_, __) => _staticPlaceholder(context),
              errorWidget: (_, __, ___) =>
                  _textPlaceholder(context, placeholderText),
            )
          : _textPlaceholder(context, placeholderText),
    );
  }

  Widget _textPlaceholder(BuildContext context, String placeholderText) {
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

  Widget _staticPlaceholder(BuildContext context) {
    return Container(
      height: size * 2,
      width: size * 2,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
    );
  }
}
