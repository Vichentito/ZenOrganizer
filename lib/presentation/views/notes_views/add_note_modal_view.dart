// En add_todo_modal.dart
import 'package:flutter/material.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';

class AddNoteModal extends StatefulWidget {
  final NotesModel? existingNote;
  final void Function(
    String title,
    String content,
    DateTime creationDate,
    List<String> tags,
  ) onAdd;

  const AddNoteModal({Key? key, this.existingNote, required this.onAdd})
      : super(key: key);

  @override
  AddNoteModalState createState() => AddNoteModalState();
}

class AddNoteModalState extends State<AddNoteModal> {
  late String title;
  late String content;
  late DateTime creationDate;
  late List<String> tags;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      title = widget.existingNote!.title;
      titleController.text = widget.existingNote!.title;
      content = widget.existingNote!.content;
      contentController.text = widget.existingNote!.content;
      creationDate = widget.existingNote!.creationDate;
      tags = widget.existingNote!.tags;
      tagsController.text = widget.existingNote!.tags.join(', ');
    } else {
      title = '';
      content = '';
      creationDate = DateTime.now();
      tags = [];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            MediaQuery.of(context).viewInsets, // Ajusta el padding al teclado
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                ),
                onSubmitted: (value) {
                  setState(() {
                    tags.add(value);
                    tagsController.clear();
                  });
                },
              ),
              Wrap(
                spacing: 8.0, // espacio entre tags
                runSpacing: 4.0, // espacio entre las líneas de tags
                children: tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  widget.onAdd(titleController.text, contentController.text,
                      creationDate, tags);
                  // Cierra el modal
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
