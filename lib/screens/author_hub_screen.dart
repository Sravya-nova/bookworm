import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/network_service.dart';
import '../models/author_models.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/pie_chart.dart';

class AuthorHubScreen extends StatefulWidget {
  const AuthorHubScreen({super.key});

  @override
  State<AuthorHubScreen> createState() => _AuthorHubScreenState();
}

class _AuthorHubScreenState extends State<AuthorHubScreen> {
  final NetworkService _networkService = NetworkService();
  late Future<AuthorHubStats> _hubStatsFuture;

  @override
  void initState() {
    super.initState();
    _hubStatsFuture = _networkService.fetchAuthorHubStats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthorHubStats>(
      future: _hubStatsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data;
        if (stats == null) return const Center(child: Text('Initialize your author hub by writing!'));

        // If stats are empty, show a "Demo" mode overlay or data to guide the user
        final isNewUser = stats.totalRoyalties == 0 && stats.totalReaders == 0;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Author Hub',
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isNewUser)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BookwormColors.tertiary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('DEMO MODE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: BookwormColors.tertiary)),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _StatCard(
              title: 'TOTAL ROYALTIES',
              value: isNewUser ? '\$0.00' : '\$${stats.totalRoyalties.toStringAsFixed(2)}',
              icon: Icons.payments_outlined,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SmallStatCard(
                    title: 'READERS',
                    value: isNewUser ? '0' : _formatLargeNumber(stats.totalReaders),
                    icon: Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SmallStatCard(
                    title: 'DRAFTS',
                    value: stats.activeDrafts.toString(),
                    icon: Icons.history_edu,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'READER DISTRIBUTION',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: BookwormColors.outline,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 140,
                    child: SimplePieChart(
                      data: isNewUser ? {
                        'Initial': 1.0,
                      } : {
                        'USA': 0.4,
                        'Europe': 0.3,
                        'Asia': 0.2,
                        'Other': 0.1,
                      },
                      colors: isNewUser ? [BookwormColors.surfaceContainerHigh] : [
                        BookwormColors.primary,
                        BookwormColors.tertiary,
                        BookwormColors.secondary,
                        BookwormColors.outline,
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isNewUser ? [
                      const Text('Start publishing to see where your readers are from.', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
                    ] : [
                      _LegendItem(color: BookwormColors.primary, label: 'USA (40%)'),
                      _LegendItem(color: BookwormColors.tertiary, label: 'Europe (30%)'),
                      _LegendItem(color: BookwormColors.secondary, label: 'Asia (20%)'),
                      _LegendItem(color: BookwormColors.outline, label: 'Other (10%)'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'MONTHLY READS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: BookwormColors.outline,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            if (isNewUser)
              Container(
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BookwormColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Publish your first work to unlock growth charts.'),
              )
            else
              _MonthlyReadsChart(monthlyReads: stats.monthlyReads),
            const SizedBox(height: 32),
            _QuickActionTile(
              title: 'Manage Publications',
              subtitle: 'Update metadata or pricing',
              icon: Icons.library_books_outlined,
              onTap: () {},
            ),
            _QuickActionTile(
              title: 'Reader Analytics',
              subtitle: 'Who is reading your work?',
              icon: Icons.analytics_outlined,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  String _formatLargeNumber(int number) {
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
    return number.toString();
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BookwormColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: BookwormColors.outline,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SmallStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BookwormColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: BookwormColors.outline, size: 20),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  letterSpacing: 1,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _MonthlyReadsChart extends StatelessWidget {
  final Map<String, int> monthlyReads;

  const _MonthlyReadsChart({required this.monthlyReads});

  @override
  Widget build(BuildContext context) {
    final maxReads = monthlyReads.values.isNotEmpty
        ? monthlyReads.values.reduce((a, b) => a > b ? a : b)
        : 1;

    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BookwormColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: monthlyReads.entries.map((entry) {
          final heightFactor = entry.value / maxReads;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: heightFactor,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: BookwormColors.primary.withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: BookwormColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
