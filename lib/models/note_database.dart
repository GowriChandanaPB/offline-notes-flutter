import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_offline_database_and_theme/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  //initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  //list of note
  final List<Note> currentNotes = [];

  // create
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser; // create new note
    await isar.writeTxn(() => isar.notes.put(newNote)); // save to db
    fetchNote(); // back to screen
  }

  // read
  Future<void> fetchNote() async {
    List<Note> fetchNote = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNote);
    notifyListeners();
  }

  //update
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNote();
    }
  }

  //delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNote();
  }
}
