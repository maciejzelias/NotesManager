import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/models/note.dart';

class DatabaseServices {
  Future<Database> initializeDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, nazwa TEXT, data TEXT, tresc TEXT, stan INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNote(Note note) async {
    final Database db = await initializeDB();
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getAllNotes() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        nazwa: maps[i]['nazwa'],
        data: maps[i]['data'],
        stan: maps[i]['stan'],
        tresc: maps[i]['tresc'],
      );
    });
  }

  Future<void> updateNote(Note note) async {
    final db = await initializeDB();
    await db.update(
      'notes',
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await initializeDB();
    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
