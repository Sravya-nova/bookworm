import 'package:flutter/material.dart';

import '../theme/bookworm_colors.dart';

class BookwormBottomNav extends StatelessWidget {
  const BookwormBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home, 'Home'),
    (Icons.explore, 'Explore'),
    (Icons.forum, 'Community'),
    (Icons.edit_note, 'Writing'),
    (Icons.insights, 'Stats'),
    (Icons.hub, 'Hub'),
    (Icons.account_circle, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BookwormColors.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: BookwormColors.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final (icon, label) = _items[index];
              final selected = index == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: selected
                            ? BookwormColors.primary
                            : BookwormColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? BookwormColors.primary
                                  : BookwormColors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                            ),
                      ),
                      if (selected)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: BookwormColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
