import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/bookworm_colors.dart';
import 'network_cover_image.dart';

class BookwormAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookwormAppBar({
    super.key,
    this.showAvatar = false,
    this.avatarUrl,
    this.leadingIcon = Icons.auto_stories,
  });

  final bool showAvatar;
  final String? avatarUrl;
  final IconData leadingIcon;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Icon(leadingIcon, color: BookwormColors.primary, size: 28),
          const SizedBox(width: 10),
          Text(
            'BOOKWORM',
            style: GoogleFonts.notoSerif(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: BookwormColors.primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: BookwormColors.onSurfaceVariant),
        ),
        if (showAvatar && avatarUrl != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClipOval(
              child: NetworkCoverImage(
                url: avatarUrl!,
                width: 36,
                height: 36,
              ),
            ),
          ),
        ] else
          const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: BookwormColors.outlineVariant),
      ),
    );
  }
}
