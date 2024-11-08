// book_details_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';

class BookDetailsScreen extends StatefulWidget {
  final String title;
  final String author;
  final String? coverUrl;
  final String bookKey;

  BookDetailsScreen({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.bookKey,
  });

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ApiService _apiService = ApiService();
  String _synopsis = 'Loading...';
  List<Map<String, dynamic>> _otherBooks = [];
  bool _isLoadingDetails = true;
  bool _isLoadingRelatedBooks = true; // Separate loading state for related books

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
    _fetchBooksByAuthor();
  }

  Future<void> _fetchBookDetails() async {
    final details = await _apiService.fetchBookDetails(widget.bookKey);
    setState(() {
      _synopsis = details['synopsis'];
      _isLoadingDetails = false;
    });
  }

  Future<void> _fetchBooksByAuthor() async {
    final books = await _apiService.fetchBooksByAuthor(widget.author, widget.title);
    setState(() {
      _otherBooks = books;
      _isLoadingRelatedBooks = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.coverUrl != null
                ? Image.network(
              widget.coverUrl!,
              height: 300,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.book, size: 200),
            )
                : Icon(Icons.book, size: 100),
            SizedBox(height: 10),
            Text(
              'Title: ${widget.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Author: ${widget.author}'),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            _isLoadingDetails ? CircularProgressIndicator() : Text(_synopsis),
            SizedBox(height: 20),
            Text(
              'More Books by ${widget.author}:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _isLoadingRelatedBooks
                ? CircularProgressIndicator()
                : _otherBooks.isEmpty
                ? Text('No additional books found.')
                : Column(
              children: _otherBooks.map((book) {
                return BookCard(
                  title: book['title'],
                  author: widget.author,
                  coverUrl: book['cover'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(
                          title: book['title'],
                          author: widget.author,
                          coverUrl: book['cover'],
                          bookKey: book['key'],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
