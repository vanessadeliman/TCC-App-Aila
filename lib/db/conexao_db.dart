import 'dart:developer';

import 'package:aila/db/modelos/analise.dart';
import 'package:aila/db/modelos/caixa.dart';
import 'package:aila/db/modelos/coleta.dart';
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
        data TEXT,
        favorito INTEGER,
        precisao REAL,
        observasoes TEXT
      );
    ''');
    await db.execute('''  CREATE TABLE IF NOT EXISTS coletas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        analiseid INTEGER,
        path TEXT
      );
    ''');
    await db.execute('''  CREATE TABLE IF NOT EXISTS celulas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        coletaid INTEGER,
        confianca INTEGER,
        indice INTEGER,
        nome TEXT
      );
    ''');
    await db.execute('''  CREATE TABLE IF NOT EXISTS caixas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        celulaid INTEGER,
        x1 REAL,
        x2 REAL,
        y1 REAL,
        y2 REAL
      );
    ''');
  }

  Future<int> insertAnalise(Analise analise) async {
    try {
      final db = await database;
      final int id = await db.insert('analises', analise.toMap());
      for (var coleta in analise.coletas) {
        final int coletaid =
            await db.rawInsert('INSERT INTO coletas(analiseid, path)'
                ' VALUES($id, "${coleta.path}")');
        for (var celula in coleta.celula) {
          final int celulaid = await db.rawInsert(
              'INSERT INTO celulas(coletaid, confianca, indice, nome)'
              ' VALUES($coletaid, ${celula.confianca}, ${celula.indice}, "${celula.nome}")');
          await db.rawInsert('INSERT INTO caixas(celulaid, x1, x2, y1, y2 )'
              ' VALUES($celulaid, ${celula.caixa.x1}, ${celula.caixa.x2}, ${celula.caixa.y1}, ${celula.caixa.y2})');
        }
      }
      return id;
    } catch (e) {
      log('Ocorreu um erro ao salvar uma analise');
      rethrow;
    }
  }

  Future<int> updateAnalise(Analise analise) async {
    final db = await database;
    return await db.update('analises', analise.toMap(),
        where: 'id = ?', whereArgs: [analise.id]);
  }

  /// Função para buscar todas as análises.
  Future<List<Map<String, dynamic>>> fetchAnalyses(Database db) async {
    return await db.query('analises');
  }

  /// Função para buscar todas as coletas relacionadas a uma análise.
  Future<List<Map<String, dynamic>>> fetchColetas(
      Database db, int analiseId) async {
    return await db
        .query('coletas', where: 'analiseid = ?', whereArgs: [analiseId]);
  }

  /// Função para buscar todas as células relacionadas a uma coleta.
  Future<List<Map<String, dynamic>>> fetchCelulas(
      Database db, int coletaId) async {
    return await db
        .query('celulas', where: 'coletaid = ?', whereArgs: [coletaId]);
  }

  /// Função para buscar todas as caixas relacionadas a uma célula.
  Future<List<Map<String, dynamic>>> fetchCaixas(
      Database db, int celulaId) async {
    return await db
        .query('caixas', where: 'celulaid = ?', whereArgs: [celulaId]);
  }

  Future<List<Analise>> getBanco() async {
    final db = await database;
    final analyses = await fetchAnalyses(db);
    List<Analise> analises = List.generate(
        analyses.length, (index) => Analise.fromMap(analyses[index]));

    for (var analise in analises) {
      // Buscar coletas relacionadas à análise
      final coletas = await fetchColetas(db, analise.id);
      analise.coletas = List.generate(
          coletas.length, (index) => Coleta.fromMap(coletas[index]));

      for (var coleta in analise.coletas) {
        // Buscar células relacionadas à coleta
        final celulas = await fetchCelulas(db, coleta.id);
        coleta.celula = List.generate(
            celulas.length, (index) => Celulas.fromMap(celulas[index]));
        for (var celula in coleta.celula) {
          // Buscar caixas relacionadas à célula
          final caixas = await fetchCaixas(db, celula.id);
          List<Caixa> caixa = List.generate(
              caixas.length, (index) => Caixa.fromMap(caixas[index]));
          celula.caixa = caixa.first; // Anexar caixas à célula
        }
      }
    }

    return analises;
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
