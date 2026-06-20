import 'package:flutter/material.dart';

import 'app.dart';
import 'theme/bookworm_theme.dart';

void main() {
  runApp(const BookwormAppRoot());
}

class BookwormAppRoot extends StatelessWidget {
  const BookwormAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookworm',
      debugShowCheckedModeBanner: false,
      theme: BookwormTheme.light(),
      home: const BookwormApp(),
    );
  }
}
