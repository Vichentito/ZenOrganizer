import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';
import 'package:zen_organizer/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:zen_organizer/presentation/views/notes_views/add_note_modal_view.dart';
import 'package:zen_organizer/presentation/views/notes_views/noteItem_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  NotesViewState createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {
  late NotesBloc notesBloc;
  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notesBloc.add(LoadNotes());
    });
  }

  void _showAddNoteModal(BuildContext context) {
    final notesBloc = context.read<NotesBloc>();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddNoteModal(
          onAdd: (String title, String content, DateTime creationDate,
              List<String> tags) {
            final newNote = NotesModel(
              id: '',
              title: title,
              content: content,
              creationDate: creationDate,
              tags: tags,
            );
            notesBloc.add(AddNote(newNote));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddNoteModal(context),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            print("State: $state");
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesContent) {
              return MasonryGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) => NoteItemView(
                      note: state.notes[index],
                      onDelete: () {
                        context
                            .read<NotesBloc>()
                            .add(DeleteNote(state.notes[index].id));
                      }));
            } else if (state is NotesError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            return const Center(
              child: Text('No hay notas'),
            );
          },
        ));
  }
}
