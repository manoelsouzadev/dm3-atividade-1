import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/book.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _dbName = 'biblioteca.db';
  static const _dbVersion = 1;
  static const tableBooks = 'books';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableBooks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            autor TEXT NOT NULL,
            ano INTEGER NOT NULL,
            genero TEXT NOT NULL,
            paginas INTEGER NOT NULL
          );
        ''');
      },
    );
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final maps = await db.query(tableBooks, orderBy: 'titulo COLLATE NOCASE');
    return maps.map((m) => Book.fromMap(m)).toList();
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(tableBooks, book.toMap()..remove('id'));
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      tableBooks,
      book.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(tableBooks, where: 'id = ?', whereArgs: [id]);
  }
}