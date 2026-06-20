import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/sample_data.dart';
import '../models/book.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/book_cover_card.dart';
import '../widgets/editorial_background.dart';
import '../widgets/network_cover_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = SampleData.currentReading;

    return EditorialBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        children: [
          _SectionHeader(
            title: 'Continue Reading',
            trailing: _StreakBadge(days: 15),
          ),
          const SizedBox(height: 16),
          _ContinueReadingCard(book: book),
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
                onPressed: () {},
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SampleData.recommendations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                return BookCoverCard(book: SampleData.recommendations[index]);
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
          _CommunityPreview(),
        ],
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
          color: BookwormColors.tertiary.withValues(alpha: 0.2),
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
  const _ContinueReadingCard({required this.book});

  final ReadingBook book;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: BookwormColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: BookwormColors.primary.withValues(alpha: 0.08),
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
                    onPressed: () {},
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCwHzT_5gQsIXEYqxG-KthroF7BW2pg0mdPtsof11u_f9mZZiXEZcssLkGpHcyWdNnzpuWL4qDG_OuHXBcCsQ7-PLgq-ld8QdfZk-goJixs5oQva2SAP8RL8yDJG5uldjRArBdQICSDuG6WPB_PP0_IqBXCdA0uGWIBWFITwSQFq5y8wQHaiCNW1uyOHywQzFan95gb7c6ghJJFRSUTKBS9BoK9WnU4czorI5VUCHpS3G4QgTU67kHRYNay1N09lRGAiIc-URwkexA',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: BookwormColors.surfaceContainer),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.2),
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
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuARHoMhGwWMCX8xBdImewB1cPpv3HjfsaudEPzq25igkogS2GLRpGBek8CCB3PwFENlNac8CE7Z_NspLan6HlCrK_kAmwjD5vYoNSgNATivgUpHT6KefoiF0SP8wk0OTkRbNXJqKqg_NHyG8fgwYsw9T3OLXTp1gRHPxXomHYAzvafrL3MyrAD5a_kKU-jTfQ8GMUam9Kw0S697gS7cXqw5UdQwT-VuAh6HoNy6ek74BQVFWjII-ZFuBVj1vyOCeasJg1UebQH_Otk',
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
                                color: Colors.white.withValues(alpha: 0.9),
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
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
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
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCvct-UIvJu5sFM6IU4lxhVSRUjvzY2MHi6gd-G1i4ZDhxQ2mp_dH4PKjwsCvtobJuIMZD6VAVw1-9zfpGRW4MKERdZwBva1U3j7eZ6odg8H9ur6UO8rTi5DZi89vFyxzmFKG9bE6Smd_QPiQCqRleTc3_EMJqgGGE5MwqmTLidDtIg0YsCIIu-rBUeBPJZY1yUIlTVVPRhYVtSHCzvaj7bMOaByXqIov9dTX8-jtlhvYFi3SE4LyFuygE7GPMYL8HQu1xFNXKKF2c',
              quote:
                  '"The only way to get out of the labyrinth of suffering is to forgive."',
              likes: 428,
              liked: true,
            )),
            const SizedBox(width: 16),
            Expanded(child: _SmallCommunityCard(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCRhYko2ioeez2hp_o_jQjc37MD4AFjY6f1r0yltMb8sPWvzMRxT-_zAe9mU3Y5U-svt-mmfa6sobS3pg-3WIi1tDKwD52-aQ0ELyeXkw9LGsWclQGecxvGxngr8hxQHSo57BntXui5YJlr3U8mpjwlkcdQLMhj5h9-8_WFlaZlco4tT2Yno7OfL5VaM50qtFWRpYGUUgovRiR2Q35k637GCKwHiJQqjOib30L6HMEx-T-WoHjW0HXPwr2dyP8e9rsjxD-2uTZ-JLQ',
              quote:
                  'Setting up my reading nook for the weekend. Thriller suggestions?',
              likes: 156,
            )),
          ],
        ),
      ],
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
          color: BookwormColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: BookwormColors.primary.withValues(alpha: 0.08),
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
