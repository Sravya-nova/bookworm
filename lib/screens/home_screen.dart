import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/api_service.dart';
import '../data/network_service.dart';
import '../models/book.dart' as legacy;
import '../models/gutendex_book.dart' as guten;
import '../models/stats_models.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/book_cover_card.dart';
import '../widgets/editorial_background.dart';
import '../widgets/network_cover_image.dart';
import '../data/sample_data.dart';
import 'book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkService _networkService = NetworkService();
  final ApiService _apiService = ApiService();
  late Future<ReadingStats> _statsFuture;
  late Future<List<guten.Book>> _curatedFuture;
  
  @override
  void initState() {
    super.initState();
    _statsFuture = _networkService.fetchReadingStats();
    _curatedFuture = _apiService.fetchBooks(); // Fetches popular books by default
  }

  Future<void> _openReader(String url) async {
    // Appending an anchor to open "in the middle" (Chapter 10 for Pride & Prejudice)
    final anchorUrl = url.contains('1342-h.htm') ? '$url#link2HCH0010' : url;
    final uri = Uri.parse(anchorUrl);
    
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Record progress in Firebase
      await _networkService.recordReadingSession(pages: 15);
      if (mounted) {
        setState(() {
          _statsFuture = _networkService.fetchReadingStats();
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the book reader')),
        );
      }
    }
  }

  Future<void> _openSocial(String platform) async {
    final url = platform == 'reddit' 
      ? 'https://www.reddit.com/r/books/top/' 
      : 'https://twitter.com/search?q=bookrecommendations&src=typed_query';
    
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the community post')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditorialBackground(
      child: FutureBuilder<ReadingStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          final stats = snapshot.data;
          final currentReading = SampleData.currentReading;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              _SectionHeader(
                title: 'Continue Reading',
                trailing: _StreakBadge(days: stats?.currentStreak ?? 0),
              ),
              const SizedBox(height: 16),
              _ContinueReadingCard(
                book: currentReading,
                onTap: () => _openReader('https://www.gutenberg.org/files/1342/1342-h/1342-h.htm'),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Curated For You',
                      style: GoogleFonts.notoSerif(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final tabController = DefaultTabController.of(context);
                      tabController.animateTo(1);
                    },
                    child: const Text(
                      'Discover More',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: BookwormColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: FutureBuilder<List<guten.Book>>(
                  future: _curatedFuture,
                  builder: (context, curatedSnapshot) {
                    if (curatedSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final books = curatedSnapshot.data ?? [];
                    // Using Unsplash as a fallback proxy for "Curated" to ensure covers always show
                    final fallbackCovers = [
                      'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
                      'https://images.unsplash.com/photo-1512820790803-83ca734da794',
                      'https://images.unsplash.com/photo-1495446815901-a7297e633e8d',
                      'https://images.unsplash.com/photo-1589998059171-988d887df646',
                      'https://images.unsplash.com/photo-1541963463532-d68292c34b19',
                    ];

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        // Force a fallback cover if it's the curated section to ensure no "Classic" placeholders
                        final displayCover = index < fallbackCovers.length 
                            ? fallbackCovers[index] 
                            : book.coverUrl;

                        final legacyBook = legacy.Book(
                          title: book.title,
                          author: book.authorNames,
                          coverUrl: displayCover,
                        );
                        return BookCoverCard(
                          book: legacyBook,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsScreen(book: book),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Literary Community',
                style: GoogleFonts.notoSerif(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _CommunityPreview(
                onTap: () => _openSocial('reddit'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: BookwormColors.tertiaryFixed,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: BookwormColors.tertiary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium, size: 14, color: BookwormColors.tertiary),
          const SizedBox(width: 6),
          Text(
            '$days DAY STREAK',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: BookwormColors.onTertiaryFixed,
                  letterSpacing: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({required this.book, required this.onTap});

  final legacy.ReadingBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: BookwormColors.outlineVariant.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: BookwormColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCoverImage(
            url: book.coverUrl,
            width: 96,
            height: 144,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerif(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${(book.progress * 100).round()}% completed',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: BookwormColors.secondary,
                            ),
                      ),
                    ),
                    Text(
                      '${book.currentPage}/${book.totalPages}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: BookwormColors.secondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ReadingProgressBar(progress: book.progress),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: BookwormColors.primary,
                      foregroundColor: BookwormColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'RESUME READING',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityPreview extends StatelessWidget {
  final VoidCallback onTap;
  const _CommunityPreview({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1512820790803-83ca734da794',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: BookwormColors.surfaceContainer),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Julian's Library",
                                style: GoogleFonts.notoSerif(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '5 Books for Rainy Days',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.play_circle, color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text(
                                '1.2k',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _SmallCommunityCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
                quote:
                    '"The only way to get out of the labyrinth of suffering is to forgive."',
                likes: 428,
                liked: true,
              )),
              const SizedBox(width: 16),
              Expanded(child: _SmallCommunityCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1495446815901-a7297e633e8d',
                quote:
                    'Setting up my reading nook for the weekend. Thriller suggestions?',
                likes: 156,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallCommunityCard extends StatelessWidget {
  const _SmallCommunityCard({
    required this.imageUrl,
    required this.quote,
    required this.likes,
    this.liked = false,
  });

  final String imageUrl;
  final String quote;
  final int likes;
  final bool liked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: BookwormColors.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: BookwormColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: NetworkCoverImage(url: imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: liked
                          ? BookwormColors.primary
                          : BookwormColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$likes',
                      style: Theme.of(context).textTheme.labelSmall,
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
