import 'package:aila/db/modelos/analise.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConexao {
  static final DatabaseConexao _instance = DatabaseConexao._internal();
  factory DatabaseConexao() => _instance;

  DatabaseConexao._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aila.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS analises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        DateTime TEXT,
        corados INTEGER,
        naoCorados INTEGER,
        totalCelulas INTEGER,
        imagem TEXT,
        favorito INTEGER,
        precisao REAL,
        observasoes TEXT
      )
    ''');
  }

  Future<int> insertAnalise(Analise analise) async {
    final db = await database;
    return await db.insert('analises', analise.toMap());
  }

  Future<List<Map<String, dynamic>>> getAnalises() async {
    final db = await database;
    return await db.query('analises');
  }

  Future<List<Map<String, dynamic>>> filtrarAnalises(DateTime data) async {
    final dataFormatada = data.toIso8601String().split('T')[0];
    final db = await database;
    return await db.query('analises',
        where: 'data LIKE ?', whereArgs: ['$dataFormatada%']);
  }

  Future<void> deleteAnalise(Analise analise) async {
    final db = await database;
    await db.delete('analises', where: 'id = ?', whereArgs: [analise.id]);
  }

  Future<void> deleteAllAnalises() async {
    final db = await database;
    await db.delete('analises');
  }
}
