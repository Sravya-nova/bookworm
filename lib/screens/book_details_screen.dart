import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/gutendex_book.dart';
import '../theme/bookworm_colors.dart';
import '../widgets/network_cover_image.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  Future<void> _launchUrl() async {
    final url = book.readableUrl;
    if (url == null) return;
    
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookwormColors.background,
      appBar: AppBar(
        title: Text(
          book.title,
          style: GoogleFonts.notoSerif(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image Header
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: BookwormColors.surfaceContainer,
              ),
              child: Center(
                child: Hero(
                  tag: 'book-cover-${book.id}',
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: NetworkCoverImage(
                      url: book.coverUrl,
                      width: 220,
                      height: 320,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: GoogleFonts.notoSerif(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'by ${book.authorNames}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: BookwormColors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.download,
                          label: 'Downloads',
                          value: '${book.downloadCount}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.language,
                          label: 'Language',
                          value: book.languages.join(', ').toUpperCase(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'SUBJECTS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 2,
                          color: BookwormColors.outline,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: book.subjects.map((subject) => Chip(
                      label: Text(subject, style: const TextStyle(fontSize: 12)),
                      backgroundColor: BookwormColors.surfaceContainerLow,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    )).toList(),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: book.readableUrl != null ? _launchUrl : null,
                      icon: const Icon(Icons.menu_book),
                      label: Text(book.readableUrl != null ? 'READ NOW' : 'NOT AVAILABLE'),
                      style: FilledButton.styleFrom(
                        backgroundColor: BookwormColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: BookwormColors.outline),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: BookwormColors.outline,
                    letterSpacing: 1,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
