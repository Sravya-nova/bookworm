class AuthorProfile {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final String role; // e.g., "Author", "Bibliophile"
  final int publishedWorks;
  final int followers;
  final List<String> genres;

  AuthorProfile({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.role,
    required this.publishedWorks,
    required this.followers,
    this.genres = const [],
  });

  factory AuthorProfile.fromJson(Map<String, dynamic> json) {
    return AuthorProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String,
      role: json['role'] as String,
      publishedWorks: json['publishedWorks'] as int,
      followers: json['followers'] as int? ?? 0,
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}

class AuthorHubStats {
  final double totalRoyalties;
  final int activeDrafts;
  final int totalReaders;
  final Map<String, int> monthlyReads;

  AuthorHubStats({
    required this.totalRoyalties,
    required this.activeDrafts,
    required this.totalReaders,
    required this.monthlyReads,
  });

  factory AuthorHubStats.fromJson(Map<String, dynamic> json) {
    return AuthorHubStats(
      totalRoyalties: (json['totalRoyalties'] as num).toDouble(),
      activeDrafts: json['activeDrafts'] as int,
      totalReaders: json['totalReaders'] as int,
      monthlyReads: Map<String, int>.from(json['monthlyReads'] ?? {}),
    );
  }
}

class Draft {
  final String id;
  final String title;
  final String content;
  final DateTime lastEdited;
  final double completionPercentage;

  Draft({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
    required this.completionPercentage,
  });

  factory Draft.fromJson(Map<String, dynamic> json) {
    return Draft(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      lastEdited: DateTime.parse(json['lastEdited'] as String),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
    );
  }
}
