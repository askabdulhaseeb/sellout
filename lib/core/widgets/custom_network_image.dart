import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        ? '/'
        : placeholder.length > 1
            ? placeholder.substring(0, 2)
            : placeholder;
    if (imageURL == null || imageURL!.isEmpty) {
      return _buildPlaceholder(context, placeholderText);
    }

    return FutureBuilder<bool>(
      future: _isImageSupported(imageURL!),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // 🌀 Show loading placeholder while checking MIME type
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: size,
            width: size,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          );
        }

        // ❌ If unsupported or failed
        if (snapshot.hasError || snapshot.data == false) {
          return _buildPlaceholder(context, placeholderText);
        }

        // ✅ Safe to load
        return CachedNetworkImage(
          imageUrl: imageURL!,
          fit: fit,
          height: size,
          width: size,
          imageBuilder:
              (BuildContext context, ImageProvider<Object> imageProvider) =>
                  Image(
            image: imageProvider,
            fit: fit,
            errorBuilder: (_, __, ___) =>
                _buildPlaceholder(context, placeholderText),
          ),
          placeholder: (_, __) => Container(
            height: size,
            width: size,
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          errorWidget: (_, __, ___) =>
              _buildPlaceholder(context, placeholderText),
        );
      },
    );
  }

  // 🧠 Step 2 — Detect file type before loading it
  Future<bool> _isImageSupported(String url) async {
    try {
      final http.Response response =
          await http.head(Uri.parse(url)).timeout(const Duration(seconds: 3));
      final String contentType = response.headers['content-type'] ?? '';

      // ✅ Only allow common Flutter-safe formats
      if (contentType.contains('image/jpeg') ||
          contentType.contains('image/png') ||
          contentType.contains('image/webp') ||
          contentType.contains('image/gif')) {
        return true;
      }

      // 🚫 Block AVIF and unknown formats
      return false;
    } on SocketException {
      return false;
    } on HttpException {
      return false;
    } on FormatException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Widget _buildPlaceholder(BuildContext context, String text) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      color: color ?? Theme.of(context).dividerColor.withValues(alpha: 0.2),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }
}
