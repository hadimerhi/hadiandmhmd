import 'package:flutter/material.dart';

class BookFinder extends StatefulWidget {
  @override
  _BookFinderState createState() => _BookFinderState();
}

class _BookFinderState extends State<BookFinder> {
  String? selectedGenre;
  List<String> genres = ['Fiction', 'Non-Fiction', 'Science', 'History', 'Fantasy'];

  bool availableOnly = false;
  bool isEbook = false;

  final List<Map<String, dynamic>> books = [
    {'title': 'To Kill a Mockingbird', 'genre': 'Fiction', 'available': true, 'ebook': true},
    {'title': 'Sapiens: A Brief History of Humankind', 'genre': 'History', 'available': false, 'ebook': false},
    {'title': 'A Brief History of Time', 'genre': 'Science', 'available': true, 'ebook': true},
    {'title': 'The Hobbit', 'genre': 'Fantasy', 'available': true, 'ebook': false},
    {'title': '1984', 'genre': 'Fiction', 'available': true, 'ebook': true},
    {'title': 'The Catcher in the Rye', 'genre': 'Fiction', 'available': false, 'ebook': false},
  ];

  List<Map<String, dynamic>> get filteredBooks {
    return books.where((book) {
      final matchesGenre = selectedGenre == null || book['genre'] == selectedGenre;
      final matchesAvailability = !availableOnly || book['available'];
      final matchesEbook = !isEbook || book['ebook'];
      return matchesGenre && matchesAvailability && matchesEbook;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Finder', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Books',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedGenre,
              hint: Text('Select Genre'),
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
              items: genres.map((genre) {
                return DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              isExpanded: true,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: availableOnly,
                  onChanged: (value) {
                    setState(() {
                      availableOnly = value!;
                    });
                  },
                ),
                Text('Available Only'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isEbook,
                  onChanged: (value) {
                    setState(() {
                      isEbook = value!;
                    });
                  },
                ),
                Text('Ebook Only'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredBooks.isEmpty
                  ? Center(
                child: Text(
                  'No books found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(
                        Icons.book,
                        color: Colors.teal,
                      ),
                      title: Text(
                        book['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(book['genre']),
                      trailing: Chip(
                        label: Text(
                          book['available'] ? 'Available' : 'Unavailable',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: book['available'] ? Colors.green : Colors.red,
                      ),
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
