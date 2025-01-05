import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String baseURL = 'http://hmdbooks.atwebpages.com/book_database.php';

class Book {
  final int id;
  final String title;
  final String author;
  final String year;
  final String genre;

  Book({required this.id, required this.title, required this.author, required this.year, required this.genre});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> _books = [];
  String _bookList = '';
  String _searchQuery = '';
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    fetchBooks();  // Try fetching the books from the server
  }

  // Fetch books from the server
  Future<void> fetchBooks() async {
    try {
      final url = Uri.parse(baseURL);  // URL for the PHP server
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        List<Book> fetchedBooks = [];
        for (var row in jsonResponse['books']) {
          fetchedBooks.add(Book(
            id: int.parse(row['id']),
            title: row['title'],
            author: row['author'],
            year: row['year'],
            genre: row['genre'],
          ));
        }

        setState(() {
          _books = fetchedBooks;  // Update the books list with the fetched data
        });
      } else {
        // Handle unsuccessful server response (use hardcoded data if necessary)
        _useHardcodedBooks();
      }
    } catch (e) {
      // In case of error (e.g., no internet connection), use hardcoded data
      _useHardcodedBooks();
    }
  }

  // Fallback to hardcoded books if the server request fails
  void _useHardcodedBooks() {
    List<Book> fallbackBooks = [
      Book(id: 1, title: "To Kill a Mockingbird", author: "Harper Lee", year: "1960", genre: "Fiction"),
      Book(id: 2, title: "1984", author: "George Orwell", year: "1949", genre: "Dystopian"),
      Book(id: 3, title: "Pride and Prejudice", author: "Jane Austen", year: "1813", genre: "Romance"),
      Book(id: 4, title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: "1925", genre: "Fiction"),
      Book(id: 5, title: "Moby Dick", author: "Herman Melville", year: "1851", genre: "Adventure"),
    ];

    setState(() {
      _books = fallbackBooks;
    });
  }

  // Filter the books by search query
  List<Book> getFilteredBooks() {
    return _books.where((book) {
      final searchLower = _searchQuery.toLowerCase();
      return book.title.toLowerCase().contains(searchLower) ||
          book.author.toLowerCase().contains(searchLower) ||
          (book.genre.toLowerCase() == _selectedGenre.toLowerCase() || _selectedGenre == 'All');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField
            TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search for a book',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // DropdownButton for Genre Filter
            DropdownButton<String>(
              value: _selectedGenre,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGenre = newValue;
                  });
                }
              },
              items: ['All', 'Fiction', 'Dystopian', 'Romance', 'Adventure']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Display filtered book list
            Expanded(
              child: _books.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: getFilteredBooks().length,
                itemBuilder: (context, index) {
                  final book = getFilteredBooks()[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${book.author} | ${book.year} | ${book.genre}'),
                    ),
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


