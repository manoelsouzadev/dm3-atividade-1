import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/book.dart';
import 'add_edit_book_page.dart';
import 'book_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> _futureBooks;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _futureBooks = DbHelper.instance.getAllBooks();
    setState(() {});
  }

  void _openAdd() async {
    final created = await Navigator.push<Book?>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditBookPage()),
    );
    if (created != null) _refresh();
  }

  void _openDetails(Book book) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => BookDetailsPage(book: book)),
    );
    if (changed == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Biblioteca'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Book>>(
        future: _futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Nenhum livro cadastrado. Toque em + para adicionar.'),
              ),
            );
          }
          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final b = books[i];
              return ListTile(
                title: Text(b.titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${b.autor} • ${b.genero} • ${b.ano}'),
                trailing: Text('${b.paginas} pág.'),
                onTap: () => _openDetails(b),
              );
            },
          );
        },
      ),
    );
  }
}