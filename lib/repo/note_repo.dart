import 'package:moneytracker/database/db_helper.dart';
import 'package:moneytracker/models/note_model.dart';
import 'package:sqflite/sqflite.dart';


class NoteRepository {
  Future<Database> get _db async => DBHelper.database;

  Future<int> addNote(NoteModel note) async {
    final db = await _db;
    
    return db.insert("notes", note.toMap());
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await _db;
    final rows = await db.query(
      "notes",
      orderBy: "pinned DESC, created_at DESC",
    );
    return rows.map(NoteModel.fromMap).toList();
  }

  Future<void> deleteNote(int id) async {
    final db = await _db;
    await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  Future<void> togglePin(int id, bool pinned) async {
    final db = await _db;
    await db.update(
      "notes",
      {"pinned": pinned ? 1 : 0, "updated_at": DateTime.now().toIso8601String()},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
