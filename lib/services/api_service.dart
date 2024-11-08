// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _searchBaseUrl = 'https://openlibrary.org/search.json?title=';
  final String _authorSearchBaseUrl = 'https://openlibrary.org/search.json?author=';

  Future<List<Map<String, dynamic>>> fetchBooks(String query) async {
    final url = Uri.parse('$_searchBaseUrl$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> books = [];

      if (data['docs'] != null && data['docs'].isNotEmpty) {
        for (var book in data['docs']) {
          books.add({
            'title': book['title'] ?? 'Unknown Title',
            'author': book['author_name']?.join(', ') ?? 'Unknown Author',
            'cover': book['cover_i'] != null
                ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg'
                : null,
            'key': book['key'],
          });
        }
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Map<String, dynamic>> fetchBookDetails(String bookKey) async {
    final detailsUrl = Uri.parse('https://openlibrary.org$bookKey.json');
    final detailsResponse = await http.get(detailsUrl);

    if (detailsResponse.statusCode == 200) {
      final detailsData = jsonDecode(detailsResponse.body);

      // Extract description
      String description;
      if (detailsData['description'] is String) {
        description = detailsData['description'];
      } else if (detailsData['description'] is Map) {
        description = detailsData['description']['value'] ?? 'No description available.';
      } else {
        description = 'No description available.';
      }

      // Extract publish date or provide fallback
      String year = detailsData['publish_date'] ?? 'Year not available';

      // Simulate a rating (as Open Library does not provide a rating)
      String rating = detailsData.containsKey('ratings')
          ? detailsData['ratings'].toString()
          : 'No rating available';

      return {
        'synopsis': description,
        'rating': rating,
        'year': year,
      };
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBooksByAuthor(String author, String currentBookTitle) async {
    final url = Uri.parse('$_authorSearchBaseUrl$author');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> books = [];

      if (data['docs'] != null && data['docs'].isNotEmpty) {
        for (var book in data['docs'].take(5)) {
          if (book['title'] != currentBookTitle) {
            books.add({
              'title': book['title'] ?? 'Unknown Title',
              'cover': book['cover_i'] != null
                  ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg'
                  : null,
              'key': book['key'],
            });
          }
          if (books.length >= 3) break; // Limit to 3 related books
        }
      }
      return books;
    } else {
      throw Exception('Failed to load books by author');
    }
  }
}
