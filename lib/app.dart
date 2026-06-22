import 'package:flutter/material.dart';

import 'data/sample_data.dart';
import 'screens/community_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/writing_screen.dart';
import 'screens/author_hub_screen.dart';
import 'theme/bookworm_colors.dart';
import 'widgets/bookworm_app_bar.dart';
import 'widgets/bookworm_bottom_nav.dart';

class BookwormApp extends StatefulWidget {
  const BookwormApp({super.key});

  @override
  State<BookwormApp> createState() => _BookwormAppState();
}

class _BookwormAppState extends State<BookwormApp> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    ExploreScreen(),
    CommunityScreen(),
    WritingScreen(),
    StatsScreen(),
    AuthorHubScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookwormColors.background,
      appBar: BookwormAppBar(
        showAvatar: _currentIndex == 0,
        avatarUrl: SampleData.profileAvatar,
        leadingIcon: _getLeadingIcon(_currentIndex),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BookwormBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: _shouldShowFab(_currentIndex)
          ? FloatingActionButton(
              onPressed: () {
                final labels = ['post', 'discovery', 'dispatch', 'draft'];
                final label = _currentIndex < labels.length ? labels[_currentIndex] : 'item';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Creating new $label...')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  IconData _getLeadingIcon(int index) {
    switch (index) {
      case 1:
        return Icons.explore;
      case 2:
        return Icons.forum;
      case 3:
        return Icons.edit_note;
      case 4:
        return Icons.insights;
      case 5:
        return Icons.hub;
      case 6:
        return Icons.account_circle;
      default:
        return Icons.auto_stories;
    }
  }

  bool _shouldShowFab(int index) {
    // Show FAB for Home, Community, and Writing
    return index == 0 || index == 2 || index == 3;
  }
}
