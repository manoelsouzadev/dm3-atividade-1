import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/book.dart';
import 'add_edit_book_page.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;
  const BookDetailsPage({super.key, required this.book});

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir livro?'),
        content: Text('Tem certeza que deseja excluir "${book.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (ok == true) {
      await DbHelper.instance.deleteBook(book.id!);
      if (context.mounted) Navigator.pop(context, true);
    }
  }

  void _edit(BuildContext context) async {
    final updated = await Navigator.push<Book?>(
      context,
      MaterialPageRoute(builder: (_) => AddEditBookPage(book: book)),
    );
    if (updated != null && context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Livro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.titulo, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipInfo(icon: Icons.person, label: book.autor),
                _ChipInfo(icon: Icons.category, label: book.genero),
                _ChipInfo(icon: Icons.calendar_today, label: book.ano.toString()),
                _ChipInfo(icon: Icons.menu_book, label: '${book.paginas} páginas'),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _edit(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _delete(context),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Excluir'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ChipInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}