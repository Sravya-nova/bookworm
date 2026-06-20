import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/network_service.dart';
import '../models/author_models.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/network_cover_image.dart';
import 'stats_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final NetworkService _networkService = NetworkService();
  late Future<AuthorProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _networkService.fetchAuthorProfile('user_123');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthorProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final profile = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: BookwormColors.primary),
                      ),
                      child: ClipOval(
                        child: NetworkCoverImage(
                          url: profile.avatarUrl,
                          width: 96,
                          height: 96,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: BookwormColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: BookwormColors.surface, width: 2),
                        ),
                        child: const Icon(
                          Icons.history_edu,
                          size: 16,
                          color: BookwormColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: GoogleFonts.notoSerif(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Badge(
                            icon: Icons.history_edu,
                            label: profile.role,
                            filled: true,
                          ),
                          _Badge(label: '${profile.publishedWorks} Published Works'),
                          _Badge(label: '${profile.followers} Followers'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              profile.bio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: BookwormColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 32),
            // Reusing Stats widgets but we should ideally fetch stats here too or pass them
            const StreakCard(streak: 42), 
            const SizedBox(height: 16),
            const GoalCard(
              finished: 12,
              total: 50,
              pagesRead: 4821,
              hoursListened: 32.5,
            ),
          ],
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    this.icon,
    this.filled = false,
  });

  final String label;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled
            ? BookwormColors.primaryContainer
            : BookwormColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: filled
                  ? BookwormColors.onPrimaryContainer
                  : BookwormColors.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: filled
                  ? BookwormColors.onPrimaryContainer
                  : BookwormColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
