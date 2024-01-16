import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';
import 'package:zen_organizer/presentation/providers/notes/notes_providers.dart';
import 'package:zen_organizer/presentation/views/notes_views/add_note_modal_view.dart';
import 'package:zen_organizer/presentation/views/notes_views/noteItem_view.dart';

class NotesView extends ConsumerStatefulWidget {
  const NotesView({super.key});

  @override
  NotesViewState createState() => NotesViewState();
}

class NotesViewState extends ConsumerState<NotesView> {
  @override
  void initState() {
    super.initState();
    ref.read(notesStateProvider.notifier).loadNotes();
  }

  void _showAddNoteModal(BuildContext context) {
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
            ref.read(notesStateProvider.notifier).addNoteInFirestore(newNote);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesStateProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddNoteModal(context),
          child: const Icon(Icons.add),
        ),
        body: notesState.notesList.when(
            data: (notes) {
              return MasonryGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: notes.length,
                  itemBuilder: (context, index) => NoteItemView(
                      note: notes[index],
                      onDelete: () {
                        ref
                            .read(notesStateProvider.notifier)
                            .deleteNoteFromFirestore(notes[index].id);
                      }));
            },
            error: (err, stack) => Center(
                  child: Text('Error: $err'),
                ),
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
