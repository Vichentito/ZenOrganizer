import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';

abstract class NotesDataSource {
  Future<List<NotesModel>> getNotes();
  Future<NotesModel> getNoteById(String id);
  Future<NotesModel> createNote(NotesModel noteItem);
  Future<NotesModel> updateNote(String id, NotesModel noteItem);
  Future<void> deleteNote(String id);
}
