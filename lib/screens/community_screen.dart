import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/sample_data.dart';
import '../models/book.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/network_cover_image.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Text(
          'The Daily Journal',
          style: GoogleFonts.notoSerif(
            fontSize: 36,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          'Dispatches from the global literary circle.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: BookwormColors.onSurfaceVariant,
                fontWeight: FontWeight.w300,
              ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _FilterChip(label: 'Latest', selected: true),
            const SizedBox(width: 8),
            _FilterChip(label: 'Curated', selected: false),
          ],
        ),
        const SizedBox(height: 24),
        _PromotedAuthorCard(),
        const SizedBox(height: 32),
        ...SampleData.communityPosts.map(
          (post) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: _FeedCard(post: post),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.expand_more),
            label: const Text('LOAD MORE DISPATCHES'),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? BookwormColors.surfaceContainerHigh
            : BookwormColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 12,
            ),
      ),
    );
  }
}

class _PromotedAuthorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BookwormColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: NetworkCoverImage(
                  url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA-5Jh0JWFHGRqZ1d93yyfjrHcel1Hf1NjpZKQUYFJLUdXnkeoSQAZAQcF98ocEtBVfOSdLm1qBK_t2V45rMUk_J53xqvEL_r1v_P1KOb3LveQrt9yyq5EUeERxE3iGQbgrAG4ROjJ2PcqQZJRCOnvitC_3fzKMx9UIlSB15ucvgI08doufSneXXc2WY_bxjGfSCoy6PUkkKubS_g_31Ovlna8QIFBbk3r0k4FRs9fZ7mM4iWdZ4-WS9J57JNx6QvpIo6q3GwDsIRI',
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: BookwormColors.tertiary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        'PROMOTED',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AUTHOR EXCLUSIVE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: BookwormColors.tertiary,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Shadows of the Hellenic Coast',
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"A haunting meditation on history, memory, and the ghosts of our ancestors."',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: BookwormColors.onSurfaceVariant,
                        fontWeight: FontWeight.w300,
                      ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    CircleAvatar(radius: 16, backgroundColor: BookwormColors.outlineVariant),
                    SizedBox(width: 12),
                    Text('Celia Thorne', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: BookwormColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text('Read First Chapter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetworkCoverImage(url: post.imageUrl, fit: BoxFit.cover),
              ),
              if (post.isVideo)
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                  ),
                ),
              if (post.isVideo)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'VLOG',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${post.handle} • ${post.timeAgo}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: BookwormColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          post.title,
          style: GoogleFonts.notoSerif(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          post.excerpt,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.6),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _InteractionButton(icon: Icons.favorite_border, label: _formatCount(post.likes)),
            const SizedBox(width: 24),
            _InteractionButton(icon: Icons.chat_bubble_outline, label: '${post.comments}'),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined),
              color: BookwormColors.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}

class _InteractionButton extends StatelessWidget {
  const _InteractionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: BookwormColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
