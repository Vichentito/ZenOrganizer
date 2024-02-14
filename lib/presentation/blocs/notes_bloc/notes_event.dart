part of 'notes_bloc.dart';

abstract class NotesEvent {
  const NotesEvent();
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final NotesModel note;
  const AddNote(this.note);
}

class UpdateNote extends NotesEvent {
  final NotesModel note;
  const UpdateNote(this.note);
}

class GetNote extends NotesEvent {
  final String id;
  const GetNote(this.id);
}

class DeleteNote extends NotesEvent {
  final String id;
  const DeleteNote(this.id);
}
