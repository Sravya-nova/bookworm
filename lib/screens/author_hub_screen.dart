import 'package:flutter/material.dart';
import '../theme/bookworm_colors.dart';

class AuthorHubScreen extends StatelessWidget {
  const AuthorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hub, size: 64, color: BookwormColors.primary),
          SizedBox(height: 16),
          Text(
            'Author Hub',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Manage your publications and connect with other authors.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
