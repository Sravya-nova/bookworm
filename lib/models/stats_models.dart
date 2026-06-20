class ReadingStats {
  final int currentStreak;
  final int pagesRead;
  final double hoursListened;
  final int booksFinished;
  final int totalGoal;
  final Map<String, double> genreBreakdown; // Genre name to percentage

  ReadingStats({
    required this.currentStreak,
    required this.pagesRead,
    required this.hoursListened,
    required this.booksFinished,
    required this.totalGoal,
    required this.genreBreakdown,
  });

  double get progress => booksFinished / totalGoal;

  factory ReadingStats.fromJson(Map<String, dynamic> json) {
    return ReadingStats(
      currentStreak: json['currentStreak'] as int,
      pagesRead: json['pagesRead'] as int,
      hoursListened: (json['hoursListened'] as num).toDouble(),
      booksFinished: json['booksFinished'] as int,
      totalGoal: json['totalGoal'] as int,
      genreBreakdown: Map<String, double>.from(json['genreBreakdown'] ?? {}),
    );
  }
}
