// search_and_results_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class SearchAndResultsScreen extends StatefulWidget {
  @override
  _SearchAndResultsScreenState createState() => _SearchAndResultsScreenState();
}

class _SearchAndResultsScreenState extends State<SearchAndResultsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Map<String, dynamic>> _books = [];

  void _searchBooks() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _books.clear();
      });

      // Fetch books from the API
      final books = await _apiService.fetchBooks(_searchController.text);

      setState(() {
        _books = books;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search for a Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(labelText: 'Enter book title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book title';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchBooks,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : _books.isEmpty
                ? Text('No results found.')
                : Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return BookCard(
                    title: book['title'],
                    author: book['author'],
                    coverUrl: book['cover'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(
                            title: book['title'],
                            author: book['author'],
                            coverUrl: book['cover'],
                            bookKey: book['key'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
