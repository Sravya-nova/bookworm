import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/network_service.dart';
import '../models/author_models.dart';
import '../theme/bookworm_colors.dart';
import 'writing_editor_screen.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final NetworkService _networkService = NetworkService();
  late Future<List<Draft>> _draftsFuture;

  @override
  void initState() {
    super.initState();
    _refreshDrafts();
  }

  void _refreshDrafts() {
    setState(() {
      _draftsFuture = _networkService.fetchDrafts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Draft>>(
      future: _draftsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final drafts = snapshot.data ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Text(
              'Writing Studio',
              style: GoogleFonts.notoSerif(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Craft your next literary masterpiece.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BookwormColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _DraftActionCard(
                  icon: Icons.add_circle_outline,
                  label: 'New Draft',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WritingEditorScreen(),
                      ),
                    );
                    _refreshDrafts(); // Always refresh when coming back
                  },
                ),
                const SizedBox(width: 16),
                _DraftActionCard(
                  icon: Icons.campaign_outlined,
                  label: 'Promote',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening promotion studio...')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'ACTIVE DRAFTS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: BookwormColors.outline,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            if (drafts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('No active drafts yet. Start writing!'),
                ),
              )
            else
              ...drafts.map((draft) => _DraftTile(
                draft: draft,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WritingEditorScreen(draft: draft),
                    ),
                  );
                  _refreshDrafts(); // Always refresh when coming back
                },
              )),
          ],
        );
      },
    );
  }
}

class _DraftActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DraftActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: BookwormColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BookwormColors.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(icon, color: BookwormColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftTile extends StatelessWidget {
  final Draft draft;
  final VoidCallback onTap;

  const _DraftTile({required this.draft, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BookwormColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BookwormColors.outlineVariant.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      draft.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.more_vert, size: 20, color: BookwormColors.outline),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Last edited ${_formatDate(draft.lastEdited)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: draft.completionPercentage,
                  minHeight: 4,
                  backgroundColor: BookwormColors.surfaceContainer,
                  color: BookwormColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(draft.completionPercentage * 100).round()}% Complete',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
