import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gutendex_book.dart' as guten;
import '../models/author_models.dart';
import '../models/stats_models.dart';
import 'firebase_service.dart';

class NetworkService {
  static const String _gutendexBaseUrl = 'https://gutendex.com/books/';
  
  final http.Client _client;
  final FirebaseService _firebaseService = FirebaseService();

  NetworkService({http.Client? client}) : _client = client ?? http.Client();

  // --- Gutendex API (Books) ---

  Future<guten.BookResponse> fetchBooks({String? query, int? page}) async {
    final queryParameters = <String, String>{};
    if (query != null && query.isNotEmpty) queryParameters['search'] = query;
    if (page != null) queryParameters['page'] = page.toString();

    final uri = Uri.parse(_gutendexBaseUrl).replace(queryParameters: queryParameters);
    
    final response = await _client.get(uri);
    if (response.statusCode == 200) {
      return guten.BookResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load books from Gutendex');
    }
  }

  // --- Author & Profile API ---

  Future<AuthorProfile> fetchAuthorProfile(String userId) async {
    final firebaseProfile = await _firebaseService.fetchProfile();
    if (firebaseProfile != null) return firebaseProfile;

    return AuthorProfile(
      id: userId,
      name: 'New Bibliophile',
      bio: 'Ready to discover new worlds.',
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      role: 'Reader',
      publishedWorks: 0,
      followers: 0,
      genres: [],
    );
  }

  Future<void> updateProfile(AuthorProfile profile) async {
    await _firebaseService.updateProfile(profile);
  }

  Future<void> notifyWorkPublished() async {
    await _firebaseService.incrementPublishedWorks();
  }

  // --- Reading Stats API ---

  Future<ReadingStats> fetchReadingStats() async {
    final firebaseStats = await _firebaseService.fetchReadingStats();
    if (firebaseStats != null) return firebaseStats;

    return ReadingStats(
      currentStreak: 0,
      pagesRead: 0,
      hoursListened: 0.0,
      booksFinished: 0,
      totalGoal: 10,
      reviewStreak: 0,
      genreBreakdown: {},
    );
  }

  Future<void> recordReadingSession({int pages = 10}) async {
    await _firebaseService.incrementStreak();
    await _firebaseService.addPagesRead(pages);
  }

  Future<void> recordBookFinished() async {
    await _firebaseService.finishBook();
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
  }

  // --- Author Hub & Writing API ---

  Future<AuthorHubStats> fetchAuthorHubStats() async {
    final profile = await _firebaseService.fetchProfile();
    final drafts = await _firebaseService.fetchDrafts();
    
    return AuthorHubStats(
      totalRoyalties: (profile?.publishedWorks ?? 0) * 125.50,
      activeDrafts: drafts.length,
      totalReaders: (profile?.followers ?? 0) * 5,
      monthlyReads: {
        'Jan': (profile?.publishedWorks ?? 0) > 0 ? 450 : 0,
        'Feb': (profile?.publishedWorks ?? 0) > 0 ? 520 : 0,
        'Mar': (profile?.publishedWorks ?? 0) > 0 ? 610 : 0,
      },
    );
  }

  Future<List<Draft>> fetchDrafts() async {
    return await _firebaseService.fetchDrafts();
  }

  Future<String> saveDraft({String? id, required String title, required String content, double progress = 0.0}) async {
    return await _firebaseService.saveDraft(id: id, title: title, content: content, progress: progress);
  }

  void dispose() {
    _client.close();
  }
}
