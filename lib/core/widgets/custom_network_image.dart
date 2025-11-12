import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageURL;
  final String placeholder;
  final BoxFit fit;
  final double? size;
  final Color? color;

  const CustomNetworkImage({
    super.key,
    required this.imageURL,
    this.placeholder = '/',
    this.fit = BoxFit.cover,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // If URL is empty or null, show placeholder
    if (imageURL == null || imageURL!.isEmpty) {
      return _buildPlaceholder(context);
    }

    return CachedNetworkImage(
      imageUrl: imageURL!,
      fit: fit,
      height: size,
      width: size,
      placeholder: (_, __) => _buildLoading(context),
      errorWidget: (_, __, ___) => _buildPlaceholder(context),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: Theme.of(context).dividerColor.withOpacity(0.2),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      color: color ?? Theme.of(context).dividerColor.withOpacity(0.2),
      child: Text(
        placeholder.isEmpty
            ? '/'
            : placeholder
                .substring(0, placeholder.length > 2 ? 2 : 1)
                .toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }
}
