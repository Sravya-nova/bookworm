import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/network_service.dart';
import '../data/api_service.dart';
import '../models/stats_models.dart';
import '../models/gutendex_book.dart' as guten;
import '../models/book.dart' as legacy;
import '../theme/bookworm_colors.dart';
import '../widgets/book_cover_card.dart';
import 'book_details_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final NetworkService _networkService = NetworkService();
  final ApiService _apiService = ApiService();
  late Future<ReadingStats> _statsFuture;
  late Future<List<guten.Book>> _recentlyFinishedFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _networkService.fetchReadingStats();
    _recentlyFinishedFuture = _apiService.fetchBooks(query: 'popular');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReadingStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data ?? ReadingStats(
          currentStreak: 0,
          pagesRead: 0,
          hoursListened: 0,
          booksFinished: 0,
          totalGoal: 10,
          reviewStreak: 0,
          genreBreakdown: {},
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
          children: [
            Text(
              'Reading Insights',
              style: GoogleFonts.notoSerif(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            StreakCard(streak: stats.currentStreak),
            const SizedBox(height: 16),
            GoalCard(
              finished: stats.booksFinished,
              total: stats.totalGoal,
              pagesRead: stats.pagesRead,
              hoursListened: stats.hoursListened,
              reviewStreak: stats.reviewStreak,
            ),
            const SizedBox(height: 16),
            GenreBreakdownCard(breakdown: stats.genreBreakdown),
            const SizedBox(height: 16),
            _RecentlyFinishedSection(future: _recentlyFinishedFuture),
            const SizedBox(height: 32),
            const WeeklyInsightCard(),
          ],
        );
      },
    );
  }
}

class _RecentlyFinishedSection extends StatelessWidget {
  final Future<List<guten.Book>> future;
  const _RecentlyFinishedSection({required this.future});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: statsCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENTLY FINISHED',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: BookwormColors.onSurfaceVariant,
                      letterSpacing: 2,
                    ),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 260,
            child: FutureBuilder<List<guten.Book>>(
              future: future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final books = snapshot.data!.take(5).toList();
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return BookCoverCard(
                      book: legacy.Book(
                        title: book.title,
                        author: book.authorNames,
                        coverUrl: book.coverUrl,
                      ),
                      width: 128,
                      height: 192,
                      showBookmark: false,
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
        ],
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: statsCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT STREAK',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: BookwormColors.onSurfaceVariant,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.local_fire_department, size: 48, color: BookwormColors.primary),
              const SizedBox(width: 12),
              Text(
                '$streak',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: BookwormColors.onSurface,
                ),
              ),
            ],
          ),
          Text(
            'Days of consistent reading',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(
              14,
              (index) {
                // Streak bar progress: fill based on current streak (capped at 14 for visual)
                final isFilled = index < streak;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index == 13 ? 0 : 4),
                    height: 24,
                    decoration: BoxDecoration(
                      color: isFilled
                          ? BookwormColors.primary.withOpacity(0.4 + (index % 5) * 0.12)
                          : BookwormColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.finished,
    required this.total,
    required this.pagesRead,
    required this.hoursListened,
    required this.reviewStreak,
  });

  final int finished;
  final int total;
  final int pagesRead;
  final double hoursListened;
  final int reviewStreak;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? finished / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: statsCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2024 READING GOAL',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: BookwormColors.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$finished of $total books finished',
                      style: GoogleFonts.notoSerif(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: BookwormColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(progress * 100).round()}% Complete',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: BookwormColors.surfaceContainer,
              color: BookwormColors.primaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _StatTile(label: 'Pages Read', value: pagesRead.toString())),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(label: 'Hours Listened', value: hoursListened.toString())),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(label: 'Review Streak', value: reviewStreak.toString())),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: BookwormColors.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: BookwormColors.onSurfaceVariant,
                  fontSize: 9,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.notoSerif(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: BookwormColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class GenreBreakdownCard extends StatelessWidget {
  const GenreBreakdownCard({super.key, required this.breakdown});
  final Map<String, double> breakdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: statsCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GENRE BREAKDOWN',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: BookwormColors.onSurfaceVariant,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 24),
          if (breakdown.isEmpty)
             const Center(child: Text('Start reading to see your breakdown!'))
          else
            ...breakdown.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        Text('${(entry.value * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: entry.value,
                        minHeight: 8,
                        backgroundColor: BookwormColors.surfaceContainer,
                        color: BookwormColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class WeeklyInsightCard extends StatelessWidget {
  const WeeklyInsightCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BookwormColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: BookwormColors.primary),
              SizedBox(width: 8),
              Text('Weekly Insight', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"You\'ve been gravitating towards speculative fiction lately. This week, you reached your peak reading speed on Tuesday evening between 8 PM and 10 PM. You\'re just 3 books away from unlocking the \'Literary Archivist\' badge."',
            style: GoogleFonts.notoSerif(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: BookwormColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              label: const Text('Explore recommendations'),
              icon: const Icon(Icons.arrow_forward, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration statsCardDecoration() {
  return BoxDecoration(
    color: BookwormColors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: BookwormColors.outlineVariant),
    boxShadow: [
      BoxShadow(
        color: BookwormColors.primary.withOpacity(0.05),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
