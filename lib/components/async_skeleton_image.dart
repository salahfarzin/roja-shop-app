import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AsyncSkeletonImage extends StatefulWidget {
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
  State<AsyncSkeletonImage> createState() => _AsyncSkeletonImageState();
}

class _AsyncSkeletonImageState extends State<AsyncSkeletonImage> {
  bool _loaded = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_loaded && !_error)
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              height: widget.height,
              width: widget.width,
              color: Colors.grey[850],
            ),
          ),
        Image.network(
          widget.url,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              if (!_loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _loaded = true);
                });
              }
              return child;
            }
            return const SizedBox.shrink();
          },
          errorBuilder: (context, error, stackTrace) {
            if (!_error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _error = true);
              });
            }
            return const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            );
          },
        ),
      ],
    );
  }
}
