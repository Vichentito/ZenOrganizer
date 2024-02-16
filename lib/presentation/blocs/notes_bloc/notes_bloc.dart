import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zen_organizer/config/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesDataSource dataSource;

  NotesBloc(this.dataSource) : super(const NotesContent()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<GetNote>(_onGetNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    if (state is NotesContent) {
      emit((state as NotesContent).copyWith(isLoading: true));
      try {
        final notes = await dataSource.getNotes();
        emit((state as NotesContent).copyWith(notes: notes, isLoading: false));
      } catch (error) {
        emit((state as NotesContent)
            .copyWith(errorMessage: error.toString(), isLoading: false));
      }
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    if (state is NotesContent) {
      try {
        await dataSource.createNote(event.note);
        final notes =
            await dataSource.getNotes(); // Considerar manejar esto en memoria
        emit((state as NotesContent).copyWith(notes: notes));
      } catch (error) {
        emit((state as NotesContent).copyWith(errorMessage: error.toString()));
      }
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    if (state is NotesContent) {
      try {
        final updateNote = await dataSource.updateNote(event.note);
        final notes =
            await dataSource.getNotes(); // Considerar manejar esto en memoria
        emit((state as NotesContent)
            .copyWith(notes: notes, selectedNote: updateNote));
      } catch (error) {
        emit((state as NotesContent).copyWith(errorMessage: error.toString()));
      }
    }
  }

  Future<void> _onGetNote(GetNote event, Emitter<NotesState> emit) async {
    if (state is NotesContent) {
      try {
        final note = await dataSource.getNoteById(event.id);
        emit((state as NotesContent).copyWith(selectedNote: note));
      } catch (error) {
        emit((state as NotesContent).copyWith(errorMessage: error.toString()));
      }
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    if (state is NotesContent) {
      try {
        await dataSource.deleteNote(event.id);
        final notes =
            await dataSource.getNotes(); // Considerar manejar esto en memoria
        emit((state as NotesContent).copyWith(notes: notes));
      } catch (error) {
        emit((state as NotesContent).copyWith(errorMessage: error.toString()));
      }
    }
  }
}
