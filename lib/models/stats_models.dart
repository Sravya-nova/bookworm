class ReadingStats {
  final int currentStreak;
  final int pagesRead;
  final double hoursListened;
  final int booksFinished;
  final int totalGoal;
  final int reviewStreak;
  final Map<String, double> genreBreakdown; // Genre name to percentage

  ReadingStats({
    required this.currentStreak,
    required this.pagesRead,
    required this.hoursListened,
    required this.booksFinished,
    required this.totalGoal,
    required this.reviewStreak,
    required this.genreBreakdown,
  });

  double get progress => totalGoal > 0 ? booksFinished / totalGoal : 0.0;

  factory ReadingStats.fromJson(Map<String, dynamic> json) {
    return ReadingStats(
      currentStreak: json['currentStreak'] as int? ?? 0,
      pagesRead: json['pagesRead'] as int? ?? 0,
      hoursListened: (json['hoursListened'] as num? ?? 0.0).toDouble(),
      booksFinished: json['booksFinished'] as int? ?? 0,
      totalGoal: json['totalGoal'] as int? ?? 10,
      reviewStreak: json['reviewStreak'] as int? ?? 0,
      genreBreakdown: Map<String, double>.from(json['genreBreakdown'] ?? {}),
    );
  }
}
