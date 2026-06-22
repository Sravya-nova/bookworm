import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gutendex_book.dart';

class ApiService {
  static const String _baseUrl = 'https://gutendex.com/books/';

  /// Fetches a list of books from the Gutendex API.
  /// 
  /// [query] - Optional search term to filter results.
  /// Returns a [Future<List<Book>>] or throws an [Exception] on failure.
  Future<List<Book>> fetchBooks({String? query}) async {
    final queryParameters = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParameters['search'] = query;
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse JSON into the BookResponse model
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Clean data if necessary
        final bookResponse = BookResponse.fromJson(data);
        
        return bookResponse.results;
      } else {
        throw Exception('Failed to fetch books. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
