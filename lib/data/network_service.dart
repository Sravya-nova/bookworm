import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gutendex_book.dart' as guten;
import '../models/author_models.dart';
import '../models/stats_models.dart';

class NetworkService {
  static const String _gutendexBaseUrl = 'https://gutendex.com/books/';
  
  // Note: These would be real API endpoints in a production app.
  // For now, they serve as placeholders or point to mock servers.
  static const String _apiBaseUrl = 'https://api.bookworm-app.com/v1';

  final http.Client _client;

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
    // Simulating an API call to the Bookworm backend
    // final response = await _client.get(Uri.parse('$_apiBaseUrl/authors/$userId'));
    
    // For demonstration, returning mock data using the model
    await Future.delayed(const Duration(milliseconds: 500));
    return AuthorProfile(
      id: userId,
      name: 'Evelyn Harper',
      bio: 'Award-winning novelist and tea enthusiast. Exploring the intersection of memory and landscape.',
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      role: 'Author',
      publishedWorks: 12,
      followers: 12400,
      genres: ['Literary Fiction', 'Historical', 'Essays'],
    );
  }

  // --- Reading Stats API ---

  Future<ReadingStats> fetchReadingStats() async {
    // final response = await _client.get(Uri.parse('$_apiBaseUrl/stats'));
    
    await Future.delayed(const Duration(milliseconds: 400));
    return ReadingStats(
      currentStreak: 42,
      pagesRead: 4821,
      hoursListened: 32.5,
      booksFinished: 12,
      totalGoal: 50,
      genreBreakdown: {
        'Fiction': 0.45,
        'History': 0.25,
        'Sci-Fi': 0.20,
        'Other': 0.10,
      },
    );
  }

  // --- Author Hub & Writing API ---

  Future<AuthorHubStats> fetchAuthorHubStats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return AuthorHubStats(
      totalRoyalties: 1250.50,
      activeDrafts: 3,
      totalReaders: 5400,
      monthlyReads: {
        'Jan': 450,
        'Feb': 520,
        'Mar': 610,
      },
    );
  }

  Future<List<Draft>> fetchDrafts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Draft(
        id: '1',
        title: 'The Echoes of Byzantium',
        content: 'Chapter 1: The gold leaf was peeling...',
        lastEdited: DateTime.now().subtract(const Duration(hours: 2)),
        completionPercentage: 0.65,
      ),
      Draft(
        id: '2',
        title: 'Winter at the Library',
        content: 'It was the coldest January on record.',
        lastEdited: DateTime.now().subtract(const Duration(days: 5)),
        completionPercentage: 0.12,
      ),
    ];
  }

  void dispose() {
    _client.close();
  }
}
