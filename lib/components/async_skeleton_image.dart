import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AsyncSkeletonImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  const AsyncSkeletonImage({
    super.key,
    required this.url,
    this.height = 120,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || url.trim().isEmpty) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[850],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[600]!,
        child: Container(height: height, width: width, color: Colors.grey[850]),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
      ),
      fadeInDuration: const Duration(milliseconds: 200),
      memCacheHeight: height.toInt(),
      memCacheWidth: width == double.infinity ? null : width.toInt(),
    );
  }
}
