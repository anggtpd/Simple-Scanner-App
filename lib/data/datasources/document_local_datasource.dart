import 'package:scan_app/data/models/document_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DocumentLocalDatasource {
  DocumentLocalDatasource._init();

  static final DocumentLocalDatasource instance =
      DocumentLocalDatasource._init();

  final String tableDocuments = 'document';

  static Database? _database;

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableDocuments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      path TEXT,
      category TEXT,
      createdAt INTEGER
      )
''');
  }

  // Future<void> resetDatabase() async {
  //   final db = await instance.database;
  //   await db.execute('DROP TABLE IF EXISTS $tableDocuments');
  //   await _createDB(db, 1);
  // }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('documentscan.db');
    return _database!;
  }

  Future<void> saveDocument(DocumentModel document) async {
    final db = await instance.database;
    print('Saving document with category: ${document.category}');
    await db.insert(tableDocuments, document.toMap());
    print("Saving document: ${document.toMap()}");
    debugDatabase();
  }

  Future<void> debugDatabase() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM $tableDocuments');

    print('Database content: $result');
  }

  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await instance.database;
    final result = await db.query(tableDocuments, orderBy: 'createdAt DESC');
    return result.map((map) => DocumentModel.fromMap(map)).toList();
  }

  Future<List<DocumentModel>> getDocumentByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(tableDocuments,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'createdAt DESC');

    // print('Fetching documents for category: $category');
    // print('Results: $result'); // Debug print
    return result.map((map) => DocumentModel.fromMap(map)).toList();
  }

  Future<void> deleteDocumentById(int id) async {
    final db = await instance.database;
    await db.delete(
      tableDocuments,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDocumentById(int id, String newName) async {
    final db = await instance.database;
    final result = await db.update(tableDocuments, {'name': newName},
        where: 'id = ?', whereArgs: [id]);

    print('Results: $result');
    print('NEW NAME: $newName');
  }
}
