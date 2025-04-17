import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pet.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database; 

  DatabaseHelper._init();

  Future<Database> get database async {
    
    if (_database != null) return _database!;
    _database = await _initDB('happypaw.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    
    await db.execute('''
      CREATE TABLE pets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        breed TEXT NOT NULL,
        gender TEXT NOT NULL,
        age TEXT NOT NULL,
        weight TEXT NOT NULL,
        location TEXT NOT NULL,
        about TEXT,
        imagePath TEXT,
        ownerName TEXT NOT NULL,
        ownerMessage TEXT,
        contactChat TEXT,
        contactPhone TEXT
      )
    ''');
  }

  Future<List<Pet>> getAllPets() async {
    final db = await instance.database;
    final result = await db.query('pets');
    return result.map((map) => Pet.fromMap(map)).toList();
  }

  Future<int> insertPet(Pet pet) async {
    final db = await instance.database;
    return await db.insert('pets', pet.toMap());
  }

  Future<void> deleteAllPets() async {
    final db = await instance.database;
    await db.delete('pets');
  }

  Future<int> deletePet(int id) async {
    final db = await instance.database;
    return await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  getPet(int id) {}

  
}
