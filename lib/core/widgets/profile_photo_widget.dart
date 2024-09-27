import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({
    required this.photoUrl,
    this.size,
    this.borderRadius,
    super.key,
  });
  final String? photoUrl;
  final double? size;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: CachedNetworkImage(
        height: size,
        width: size,
        imageUrl: photoUrl ?? '',
        imageBuilder: (
          BuildContext context,
          ImageProvider<Object> imageProvider,
        ) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          );
        },
        placeholder: (BuildContext context, String url) {
          return Container(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white),
          );
        },
        errorWidget: (BuildContext context, String url, dynamic error) {
          return Container(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            child: const Icon(Icons.error_outline, color: Colors.white),
          );
        },
      ),
    );
  }
}
