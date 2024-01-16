import 'package:zen_organizer/config/domain/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/domain/repositories/notes_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';

class NotesRepositoryImpl extends NotesRepository {
  final NotesDataSource datasource;

  NotesRepositoryImpl(this.datasource);

  @override
  Future<NotesModel> createNote(NotesModel noteItem) {
    return datasource.createNote(noteItem);
  }

  @override
  Future<void> deleteNote(String id) {
    return datasource.deleteNote(id);
  }

  @override
  Future<NotesModel> getNoteById(String id) {
    return datasource.getNoteById(id);
  }

  @override
  Future<List<NotesModel>> getNotes() {
    return datasource.getNotes();
  }

  @override
  Future<NotesModel> updateNote(String id, NotesModel noteItem) {
    return datasource.updateNote(id, noteItem);
  }
}
