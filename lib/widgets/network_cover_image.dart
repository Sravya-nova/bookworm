import 'package:flutter/material.dart';

import '../theme/bookworm_colors.dart';

class NetworkCoverImage extends StatelessWidget {
  const NetworkCoverImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _placeholder();
      },
    );

    if (borderRadius == null) return image;

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: BookwormColors.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book,
        color: BookwormColors.primary.withValues(alpha: 0.5),
        size: (height ?? 80) * 0.3,
      ),
    );
  }
}
