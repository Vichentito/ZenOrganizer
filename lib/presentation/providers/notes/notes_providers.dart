import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/domain/repositories/notes_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';
import 'package:zen_organizer/presentation/providers/notes/notes_repository_provider.dart';

class NotesState {
  final AsyncValue<List<NotesModel>> notesList;

  NotesState({
    required this.notesList,
  });
}

final notesStateProvider = StateNotifierProvider<NotesNotifier, NotesState>(
  (ref) => NotesNotifier(ref.read(notesRepositoryProvider)),
);

class NotesNotifier extends StateNotifier<NotesState> {
  NotesNotifier(this._repository)
      : super(NotesState(notesList: const AsyncValue.loading()));

  final NotesRepository _repository;
  bool _hasLoadedNotes = false;
  List<NotesModel> _originalNotes = [];

  Future<void> loadNotes() async {
    if (_hasLoadedNotes) return;
    try {
      final notes = await _repository.getNotes();
      state = NotesState(notesList: AsyncValue.data(notes));
      _originalNotes = notes;
      _hasLoadedNotes = true;
    } catch (e, stackTrace) {
      state = NotesState(notesList: AsyncValue.error(e, stackTrace));
    }
  }

  Future<NotesModel> getNoteById(String id) async {
    final currentState = state.notesList;
    if (currentState is AsyncData<List<NotesModel>>) {
      final notes = currentState.value;
      final note = notes.firstWhere((note) => note.id == id);
      return note;
    }
    throw Exception('No se ha podido encontrar la nota');
  }

  void updateNoteLocally(String id, NotesModel updatedNote) {
    final currentState = state.notesList;
    if (currentState is AsyncData<List<NotesModel>>) {
      final notes = currentState.value;
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index] = updatedNote;
        // Construimos un nuevo NotesState con la lista actualizada y el valor actual de isSortedByPriority
        state = NotesState(
            notesList: AsyncValue.data(List<NotesModel>.from(notes)));
      }
    }
  }

  Future<void> updateNoteInFirestore(
      String id, NotesModel updatedNote, NotesModel originalNote) async {
    try {
      await _repository.updateNote(id, updatedNote);
    } catch (e) {
      // Revertir el cambio local si la actualización en Firestore falla
      revertLocalUpdate(id, originalNote);
    }
  }

  void revertLocalUpdate(String id, NotesModel originalNote) {
    final currentState = state.notesList;
    if (currentState is AsyncData<List<NotesModel>>) {
      final notes = currentState.value;
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index] = originalNote;
        state = NotesState(
            notesList: AsyncValue.data(List<NotesModel>.from(notes)));
      }
    }
  }

  Future<void> addNoteInFirestore(NotesModel newNote) async {
    try {
      NotesModel createdNote = await _repository.createNote(newNote);
      final currentState = state.notesList;
      if (currentState is AsyncData<List<NotesModel>>) {
        final newNotesList = List<NotesModel>.from(currentState.value)
          ..add(createdNote);
        state = NotesState(notesList: AsyncValue.data(newNotesList));
        _originalNotes = newNotesList;
      }
    } catch (e, stackTrace) {
      removeLocalNoteItem(newNote);
      state = NotesState(notesList: AsyncValue.error(e, stackTrace));
    }
  }

  void removeLocalNoteItem(NotesModel newNote) {
    final currentState = state.notesList;
    if (currentState is AsyncData<List<NotesModel>>) {
      final updatedNotesList =
          currentState.value.where((note) => note.id != newNote.id).toList();
      state = NotesState(notesList: AsyncValue.data(updatedNotesList));
    }
  }

  Future<void> deleteNoteFromFirestore(String id) async {
    try {
      await _repository.deleteNote(id);
      final currentState = state.notesList;
      if (currentState is AsyncData<List<NotesModel>>) {
        final updatedNotesList =
            currentState.value.where((note) => note.id != id).toList();
        state = NotesState(notesList: AsyncValue.data(updatedNotesList));
        _originalNotes = updatedNotesList;
      }
    } catch (e, stackTrace) {
      state = NotesState(notesList: AsyncValue.error(e, stackTrace));
    }
  }

  void searchNotes(String searchTerm) {
    if (searchTerm.isEmpty) {
      // Si no hay término de búsqueda, restablece a la lista original
      state = NotesState(notesList: AsyncValue.data(_originalNotes));
      return;
    }
    // Filtrar la lista original según el término de búsqueda
    final filteredNotes = _originalNotes
        .where((note) =>
            note.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
            note.tags.any(
                (tag) => tag.toLowerCase().contains(searchTerm.toLowerCase())))
        .toList();
    state = NotesState(notesList: AsyncValue.data(filteredNotes));
  }

  void resetSearch() {
    // Restablecer la lista a su estado original
    state = NotesState(notesList: AsyncValue.data(_originalNotes));
  }
}
