import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gutendex_book.dart';

class GutendexService {
  static const String _baseUrl = 'https://gutendex.com/books/';

  /// Fetches a list of books from Gutendex.
  /// Optional [query] can be used to search for specific books.
  /// Optional [page] for pagination.
  Future<BookResponse> fetchBooks({String? query, int? page}) async {
    final queryParameters = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParameters['search'] = query;
    }
    if (page != null) {
      queryParameters['page'] = page.toString();
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);
    
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BookResponse.fromJson(data);
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  /// Fetches a single book by its ID.
  Future<Book> fetchBookById(int id) async {
    final uri = Uri.parse('$_baseUrl$id/');
    
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        throw Exception('Failed to load book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book: $e');
    }
  }
}
