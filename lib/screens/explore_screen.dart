import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/api_service.dart';
import '../models/gutendex_book.dart' as guten;
import '../theme/bookworm_colors.dart';
import '../widgets/network_cover_image.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  List<guten.Book> _books = [];
  int _currentIndex = 0;
  Offset _dragOffset = Offset.zero;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _apiService.fetchBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  guten.Book? get _currentBook =>
      _books.isNotEmpty ? _books[_currentIndex % _books.length] : null;

  void _swipe(bool acquire) {
    if (_books.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _books.length;
      _dragOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadBooks();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final book = _currentBook;

    if (book == null) {
      return const Center(child: Text('No books found.'));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      child: Column(
        children: [
          Text(
            'SWIPE TO CURATE YOUR COLLECTION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: BookwormColors.outline,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.97,
                      child: Container(
                        decoration: BoxDecoration(
                          color: BookwormColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: BookwormColors.outlineVariant),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _dragOffset += details.delta;
                        });
                      },
                      onPanEnd: (details) {
                        if (_dragOffset.dx > 100) {
                          _swipe(true);
                        } else if (_dragOffset.dx < -100) {
                          _swipe(false);
                        } else {
                          setState(() => _dragOffset = Offset.zero);
                        }
                      },
                      child: Transform.translate(
                        offset: _dragOffset,
                        child: Transform.rotate(
                          angle: _dragOffset.dx / 400,
                          child: _DiscoveryCard(book: book, dragOffset: _dragOffset),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: Icons.close,
                onTap: () => _swipe(false),
              ),
              const SizedBox(width: 32),
              _ActionButton(
                icon: Icons.bookmark,
                filled: true,
                large: true,
                onTap: () => _swipe(true),
              ),
              const SizedBox(width: 32),
              _ActionButton(
                icon: Icons.favorite_border,
                color: BookwormColors.primary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.book, required this.dragOffset});

  final guten.Book book;
  final Offset dragOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BookwormColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkCoverImage(url: book.coverUrl, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          if (dragOffset.dx > 50)
            Positioned(
              top: 40,
              left: 40,
              child: _SwipeCue(label: 'ACQUIRE', color: BookwormColors.primary),
            ),
          if (dragOffset.dx < -50)
            Positioned(
              top: 40,
              right: 40,
              child: _SwipeCue(label: 'REJECT', color: BookwormColors.error),
            ),
          Positioned(
            left: 32,
            right: 32,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: book.subjects.take(3)
                      .map(
                        (subject) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: BookwormColors.primary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            subject.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerif(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        book.authorNames,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.download,
                      size: 14,
                      color: BookwormColors.tertiaryFixed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${book.downloadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeCue extends StatelessWidget {
  const _SwipeCue({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSerif(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.large = false,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool large;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final size = large ? 72.0 : 56.0;
    return Material(
      color: filled ? BookwormColors.primary : BookwormColors.surfaceContainerLowest,
      shape: CircleBorder(
        side: filled
            ? BorderSide.none
            : BorderSide(color: BookwormColors.outlineVariant),
      ),
      elevation: filled ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: large ? 32 : 24,
            color: filled
                ? BookwormColors.onPrimary
                : (color ?? BookwormColors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
