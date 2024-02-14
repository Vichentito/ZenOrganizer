part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();
}

class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}

class NotesLoading extends NotesState {
  @override
  List<Object> get props => [];
}

// Estado global que maneja tanto la lista de notas como la nota detallada
class NotesContent extends NotesState {
  final List<NotesModel> notes;
  final NotesModel? selectedNote;

  const NotesContent({
    this.notes = const [],
    this.selectedNote,
  });

  NotesContent copyWith({
    List<NotesModel>? notes,
    NotesModel? selectedNote,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotesContent(
      notes: notes ?? this.notes,
      selectedNote: selectedNote,
    );
  }

  @override
  List<Object?> get props => [notes, selectedNote];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}
