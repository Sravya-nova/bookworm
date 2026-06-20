class Book {
  const Book({
    required this.title,
    required this.author,
    required this.coverUrl,
    this.rating,
    this.genres = const [],
  });

  final String title;
  final String author;
  final String coverUrl;
  final double? rating;
  final List<String> genres;
}

class ReadingBook extends Book {
  const ReadingBook({
    required super.title,
    required super.author,
    required super.coverUrl,
    required this.progress,
    required this.currentPage,
    required this.totalPages,
  });

  final double progress;
  final int currentPage;
  final int totalPages;
}

class CommunityPost {
  const CommunityPost({
    required this.author,
    required this.handle,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    this.isVideo = false,
    this.timeAgo = '',
  });

  final String author;
  final String handle;
  final String title;
  final String excerpt;
  final String imageUrl;
  final int likes;
  final int comments;
  final bool isVideo;
  final String timeAgo;
}
