import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(BookApp());
}

class BookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Library',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('http://hmdbooks.atwebpages.com/book_database.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        return (jsonData['books'] as List).map((data) => Book.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load books: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to fetch data from the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Library'),
      ),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return BookListView(books: snapshot.data!);
          } else {
            return Center(child: Text('No books found.'));
          }
        },
      ),
    );
  }
}

class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final String genre;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
      genre: json['genre'],
    );
  }
}

class BookListView extends StatelessWidget {
  final List<Book> books;

  BookListView({required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(book.id.toString()),
            ),
            title: Text(
              book.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${book.author}'),
                Text('Year: ${book.year}'),
                Text('Genre: ${book.genre}'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(BookApp());
}

class BookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Library',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('http://hmdbooks.atwebpages.com/book_database.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        return (jsonData['books'] as List).map((data) => Book.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load books: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to fetch data from the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Library'),
      ),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return BookListView(books: snapshot.data!);
          } else {
            return Center(child: Text('No books found.'));
          }
        },
      ),
    );
  }
}

class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final String genre;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
      genre: json['genre'],
    );
  }
}

class BookListView extends StatelessWidget {
  final List<Book> books;

  BookListView({required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(book.id.toString()),
            ),
            title: Text(
              book.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${book.author}'),
                Text('Year: ${book.year}'),
                Text('Genre: ${book.genre}'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
