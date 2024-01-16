class NoteItem {
  final String id;
  final String title;
  final String content;
  final DateTime creationDate;
  final List<String> tags; // Una lista de etiquetas para la nota

  NoteItem(
      {required this.id,
      required this.title,
      required this.content,
      required this.creationDate,
      this.tags = const [] // Lista vacía como valor por defecto
      });
}
