import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  bool get _isSvg {
    return imageURL?.toLowerCase().endsWith('.svg') ?? false;
  }

  String get _placeholderText {
    if (placeholder.isEmpty) return '/';
    if (placeholder.length > 1) return placeholder.substring(0, 2);
    return placeholder;
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: Theme.of(context).dividerColor.withOpacity(0.2),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: color ?? Theme.of(context).dividerColor,
      alignment: Alignment.center,
      child: Text(
        _placeholderText.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageURL == null || imageURL!.isEmpty) {
      return _buildErrorWidget(context);
    }

    if (_isSvg) {
      return SvgPicture.network(
        imageURL!,
        width: size,
        height: size,
        fit: fit ?? BoxFit.contain,
        colorFilter:
            ColorFilter.mode(color ?? const Color(0xFFFFFFFF), BlendMode.color),
        placeholderBuilder: (_) => _buildPlaceholder(context),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageURL!,
      fit: fit,
      height: size,
      width: size,
      color: color,
      memCacheWidth: size != null ? (size! * 2).toInt() : null,
      memCacheHeight: size != null ? (size! * 2).toInt() : null,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 200),
      placeholder: (_, __) => _buildPlaceholder(context),
      errorWidget: (_, __, ___) => _buildErrorWidget(context),
    );
  }
}
