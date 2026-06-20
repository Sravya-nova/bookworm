import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/network_service.dart';
import '../models/stats_models.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/book_cover_card.dart';
import '../data/sample_data.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final NetworkService _networkService = NetworkService();
  late Future<ReadingStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _networkService.fetchReadingStats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReadingStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final stats = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
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
            ),
            const SizedBox(height: 16),
            GenreBreakdownCard(breakdown: stats.genreBreakdown),
            const SizedBox(height: 16),
            const RecentlyFinishedCard(),
            const SizedBox(height: 24),
            const WeeklyInsightCard(),
          ],
        );
      },
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
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 13 ? 0 : 4),
                  height: 24,
                  decoration: BoxDecoration(
                    color: index == 12
                        ? BookwormColors.primaryContainer
                        : index == 13
                            ? BookwormColors.surfaceContainerHigh
                            : BookwormColors.primary.withValues(
                                alpha: 0.2 + (index % 5) * 0.16,
                              ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
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
  });

  final int finished;
  final int total;
  final int pagesRead;
  final double hoursListened;

  @override
  Widget build(BuildContext context) {
    final progress = finished / total;
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
              Expanded(child: _StatTile(label: 'Review Streak', value: '12')),
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
          color: BookwormColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: BookwormColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.notoSerif(
              fontSize: 22,
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

class RecentlyFinishedCard extends StatelessWidget {
  const RecentlyFinishedCard({super.key});
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
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SampleData.recentlyFinished.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return BookCoverCard(
                  book: SampleData.recentlyFinished[index],
                  width: 128,
                  height: 192,
                  showBookmark: false,
                );
              },
            ),
          ),
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
        color: BookwormColors.primary.withValues(alpha: 0.05),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
