import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/book.dart';

class AddEditBookPage extends StatefulWidget {
  final Book? book;
  const AddEditBookPage({super.key, this.book});

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _autorCtrl = TextEditingController();
  final _anoCtrl = TextEditingController();
  final _generoCtrl = TextEditingController();
  final _paginasCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    if (b != null) {
      _tituloCtrl.text = b.titulo;
      _autorCtrl.text = b.autor;
      _anoCtrl.text = b.ano.toString();
      _generoCtrl.text = b.genero;
      _paginasCtrl.text = b.paginas.toString();
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _autorCtrl.dispose();
    _anoCtrl.dispose();
    _generoCtrl.dispose();
    _paginasCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final book = Book(
      id: widget.book?.id,
      titulo: _tituloCtrl.text.trim(),
      autor: _autorCtrl.text.trim(),
      ano: int.parse(_anoCtrl.text.trim()),
      genero: _generoCtrl.text.trim(),
      paginas: int.parse(_paginasCtrl.text.trim()),
    );

    if (widget.book == null) {
      await DbHelper.instance.insertBook(book);
    } else {
      await DbHelper.instance.updateBook(book);
    }

    if (mounted) Navigator.pop(context, book);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Livro' : 'Novo Livro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _autorCtrl,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o autor' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _generoCtrl,
                decoration: const InputDecoration(labelText: 'Gênero'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o gênero' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _anoCtrl,
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o ano';
                  final n = int.tryParse(v);
                  if (n == null || n < 0 || n > DateTime.now().year) return 'Ano inválido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _paginasCtrl,
                decoration: const InputDecoration(labelText: 'Páginas'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe as páginas';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Número inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? 'Salvar alterações' : 'Adicionar livro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}