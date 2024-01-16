import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/repositories/notes_repository_impl.dart';

final notesRepositoryProvider = Provider((ref) {
  return NotesRepositoryImpl(NotesdbDatasource());
});
