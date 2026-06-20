import 'package:flutter/material.dart';
import '../theme/bookworm_colors.dart';

class WritingScreen extends StatelessWidget {
  const WritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 64, color: BookwormColors.primary),
          SizedBox(height: 16),
          Text(
            'Writing & Promotion',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Draft your next masterpiece and promote it to the community.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
