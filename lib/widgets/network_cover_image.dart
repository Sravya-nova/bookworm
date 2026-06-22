import 'package:flutter/material.dart';
import '../theme/bookworm_colors.dart';

class NetworkCoverImage extends StatefulWidget {
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
  State<NetworkCoverImage> createState() => _NetworkCoverImageState();
}

class _NetworkCoverImageState extends State<NetworkCoverImage> {
  late String _currentUrl;

  @override
  void initState() {
    super.initState();
    _currentUrl = _secureUrl(widget.url);
  }

  @override
  void didUpdateWidget(NetworkCoverImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _currentUrl = _secureUrl(widget.url);
    }
  }

  String _secureUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final gutenId = _extractGutenbergId(widget.url);
    final openLibraryId = _mapGutenbergToOpenLibrary(gutenId);
    
    // If we have a mapped high-quality cover, use it. 
    // Otherwise, for classics, use a deterministic stock image to ensure variety if Gutenberg fails.
    final displayUrl = (openLibraryId != null)
        ? 'https://covers.openlibrary.org/b/id/$openLibraryId-M.jpg'
        : _currentUrl;

    Widget image = Image.network(
      displayUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        // If it's a gutenberg book, try a variety of placeholders instead of one generic one
        if (gutenId != null) {
          return _dynamicPlaceholder(gutenId);
        }
        return _placeholder(isError: true);
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _placeholder(isLoading: true);
      },
    );

    if (widget.borderRadius != null) {
      image = ClipRRect(borderRadius: widget.borderRadius!, child: image);
    }

    return image;
  }

  String? _extractGutenbergId(String url) {
    final regex = RegExp(r'/(\d+)/');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  String? _mapGutenbergToOpenLibrary(String? id) {
    if (id == null) return null;
    const mapping = {
      '1342': '10471587', // Pride and Prejudice
      '1513': '8225227',  // Romeo and Juliet
      '2701': '8231938',  // Moby Dick
      '84': '10473215',   // Frankenstein
      '11': '10473217',   // Alice in Wonderland
      '1661': '8225444',  // Sherlock Holmes
    };
    return mapping[id];
  }

  Widget _dynamicPlaceholder(String id) {
    // Generate a colorful, varied placeholder based on book ID
    final idNum = int.tryParse(id) ?? 0;
    final colors = [
      Colors.blueGrey,
      Colors.brown,
      Colors.indigo,
      Colors.deepOrange,
      Colors.teal,
      Colors.deepPurple,
    ];
    final color = colors[idNum % colors.length];

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: widget.borderRadius,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Opacity(
            opacity: 0.05,
            child: Icon(Icons.menu_book, size: (widget.height ?? 80) * 0.8),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories,
                color: color.withOpacity(0.5),
                size: (widget.height ?? 80) * 0.2,
              ),
              const SizedBox(height: 12),
              Text(
                'LITERARY\nARCHIVE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: color.withOpacity(0.6),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: $id',
                style: TextStyle(
                  fontSize: 8,
                  color: color.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder({bool isLoading = false, bool isError = false}) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLow,
        borderRadius: widget.borderRadius,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isError ? Icons.broken_image_outlined : Icons.menu_book,
            color: BookwormColors.primary.withOpacity(0.3),
            size: (widget.height ?? 80) * 0.25,
          ),
          if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
