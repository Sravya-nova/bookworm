class BookResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Book> results;

  BookResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Book {
  final int id;
  final String title;
  final List<Author> authors;
  final List<String> subjects;
  final List<String> bookshelves;
  final List<String> languages;
  final bool? copyright;
  final String mediaType;
  final Map<String, String> formats;
  final int downloadCount;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
  });

  /// Helper to get the cover image URL from the formats map.
  String get coverUrl =>
      formats['image/jpeg'] ??
      'https://via.placeholder.com/400x600.png?text=No+Cover';

  /// Helper to get a formatted string of author names.
  String get authorNames =>
      authors.map((a) => a.name).join(', ').isNotEmpty
          ? authors.map((a) => a.name).join(', ')
          : 'Unknown Author';

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjects: List<String>.from(json['subjects'] as List),
      bookshelves: List<String>.from(json['bookshelves'] as List),
      languages: List<String>.from(json['languages'] as List),
      copyright: json['copyright'] as bool?,
      mediaType: json['media_type'] as String,
      formats: Map<String, String>.from(json['formats'] as Map),
      downloadCount: json['download_count'] as int,
    );
  }
}

class Author {
  final String name;
  final int? birthYear;
  final int? deathYear;

  Author({
    required this.name,
    this.birthYear,
    this.deathYear,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] as String,
      birthYear: json['birth_year'] as int?,
      deathYear: json['death_year'] as int?,
    );
  }
}
