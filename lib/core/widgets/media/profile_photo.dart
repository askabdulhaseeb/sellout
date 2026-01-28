import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    required this.url,
    this.isCircle = false,
    this.placeholder = 'na',
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

    // ✅ Safe fallback: empty or invalid URL
    if (!isValidUrl) {
      return isCircle
          ? CircleAvatar(
              radius: size,
              backgroundColor: Theme.of(context).dividerColor.withOpacity(0.2),
              child: Text(
                placeholderText.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            )
          : _textPlaceholder(context, placeholderText);
    }

    // ✅ For circular image
    if (isCircle) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          height: size * 2,
          width: size * 2,
          placeholder: (_, _) => _staticPlaceholder(context),
          errorWidget: (_, _, _) =>
              _textPlaceholder(context, placeholderText),
          // Added protection for Flutter image decoder crash
          imageBuilder:
              (BuildContext context, ImageProvider<Object> imageProvider) =>
                  Image(
            image: imageProvider,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) =>
                    _textPlaceholder(context, placeholderText),
          ),
        ),
      );
    }

    // ✅ For rectangular image
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: url!,
        height: size * 2,
        width: size * 2,
        fit: BoxFit.cover,
        placeholder: (_, __) => _staticPlaceholder(context),
        errorWidget: (_, __, ___) => _textPlaceholder(context, placeholderText),
        imageBuilder:
            (BuildContext context, ImageProvider<Object> imageProvider) =>
                Image(
          image: imageProvider,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) =>
                  _textPlaceholder(context, placeholderText),
        ),
      ),
    );
  }

  Widget _textPlaceholder(BuildContext context, String placeholderText) {
    return Container(
      height: size * 2,
      width: size * 2,
      alignment: Alignment.center,
      color: Theme.of(context).dividerColor.withOpacity(0.2),
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
      color: Theme.of(context).dividerColor.withOpacity(0.2),
    );
  }
}
