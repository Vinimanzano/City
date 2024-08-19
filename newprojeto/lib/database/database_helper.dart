import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();

  static Database? _database;
  List<String>? _bairros;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 2, // Atualize a versão do banco de dados
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bairros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');

    if (_bairros != null) {
      await _populateBairros(db);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario TEXT NOT NULL UNIQUE,
          senha TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> _populateBairros(Database db) async {
    for (var bairro in _bairros!) {
      await db.insert('bairros', {'nome': bairro});
    }
  }

  Future<void> initializeBairros(List<String> bairros) async {
    _bairros = bairros;
    final db = await database;
    await _populateBairros(db);
  }

  Future<List<Map<String, dynamic>>> getBairros() async {
    final db = await database;
    return await db.query('bairros');
  }

  Future<void> registerUser(String username, String password) async {
    final db = await database;
    await db.insert('usuarios', {
      'usuario': username,
      'senha': password,
    });
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'usuarios',
      where: 'usuario = ? AND senha = ?',
      whereArgs: [username, password],
    );
    return results.isNotEmpty;
  }

  Future<void> resetPassword(String username, String newPassword) async {
    final db = await database;
    await db.update(
      'usuarios',
      {'senha': newPassword},
      where: 'usuario = ?',
      whereArgs: [username],
    );
  }
}
