import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zen_organizer/config/domain/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';
import 'package:zen_organizer/presentation/blocs/notes_bloc/notes_bloc.dart';

class NoteDetailsView extends StatefulWidget {
  final String noteId;

  const NoteDetailsView({Key? key, required this.noteId}) : super(key: key);

  @override
  NoteDetailsViewState createState() => NoteDetailsViewState();
}

class NoteDetailsViewState extends State<NoteDetailsView> {
  late Future<NotesModel> noteFuture;
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late NotesBloc notesBloc;
  List<String> editableTags = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    notesBloc = BlocProvider.of<NotesBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notesBloc.add(GetNote(widget.noteId));
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _updateNote(NotesModel note) {
    final updatedNote = NotesModel(
      id: note.id,
      title: titleController.text,
      content: contentController.text,
      creationDate: note.creationDate,
      tags: editableTags,
    );
    notesBloc.add(UpdateNote(updatedNote));
  }

  void _addTag(String tag) {
    setState(() {
      editableTags.add(tag);
    });
  }

  void _removeTag(String tag) {
    setState(() {
      editableTags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          print("State en view: $state");
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesContent) {
            final note = state.selectedNote;
            print("Nota: $note");
            print("Titulo: ${note?.title}");
            editableTags = note?.tags ?? [];
            titleController.text = note?.title ?? '';
            contentController.text = note?.content ?? '';
            return CustomPaint(
              painter: _NoteLinesPainter(),
              size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context)
                      .size
                      .height), // Establece el tamaño del CustomPaint
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context)
                        .size
                        .width, // Asegura el ancho mínimo
                    minHeight: MediaQuery.of(context)
                        .size
                        .height, // Asegura la altura mínima
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        isEditing
                            ? TextField(controller: titleController)
                            : Text(
                                note?.title ?? '',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(height: 8.0),
                        isEditing
                            ? TextField(
                                controller:
                                    contentController, // Establece el controlador del texto para el contenido
                                maxLines: null, // Para permitir varias líneas
                              )
                            : Text(note?.content ?? ''),
                        const SizedBox(height: 8.0),
                        isEditing
                            ? Wrap(
                                spacing:
                                    8.0, // Espacio horizontal entre los chips
                                runSpacing:
                                    4.0, // Espacio vertical entre las líneas
                                children: editableTags
                                    .map((tag) => InputChip(
                                          label: Text(tag),
                                          onDeleted: () => _removeTag(tag),
                                        ))
                                    .toList(),
                              )
                            : Wrap(
                                spacing:
                                    8.0, // Espacio horizontal entre los chips
                                runSpacing:
                                    4.0, // Espacio vertical entre las líneas
                                children: note?.tags
                                        .map((tag) => Chip(
                                              label: Text(tag),
                                            ))
                                        .toList() ??
                                    [],
                              ),
                        isEditing
                            ? TextField(
                                onSubmitted: (newTag) {
                                  _addTag(newTag);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Añadir Tag',
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is NotesError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else {
            return const Center(
              child: Text('No hay notas'),
            );
          }
        },
      ),
      floatingActionButton: isEditing
          ? FloatingActionButton(
              onPressed: () {
                if (context.read<NotesBloc>().state is NotesContent) {
                  _updateNote((context.read<NotesBloc>().state as NotesContent)
                      .selectedNote!);
                }
              },
              child: const Icon(Icons.save),
            )
          : null,
    );
  }
}

class _NoteLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1;
    const lineSpacing = 20.0; // Espaciado entre líneas
    var backgroundPaint = Paint()..color = Colors.yellow[100]!;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    for (var i = lineSpacing; i < size.height; i += lineSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
