import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gutendex_book.dart';

class ApiService {
  static const String _baseUrl = 'https://gutendex.com/books/';

  /// Fetches a list of books from the Gutendex API.
  /// 
  /// Returns a [Future<List<Book>>] or throws an [Exception] on failure.
  Future<List<Book>> fetchBooks() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse JSON into the BookResponse model
        final Map<String, dynamic> data = json.decode(response.body);
        final bookResponse = BookResponse.fromJson(data);
        
        // Return only the list of books as requested
        return bookResponse.results;
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to fetch books. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      // Handle network/connection errors
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Handle any other errors (parsing, etc.)
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
