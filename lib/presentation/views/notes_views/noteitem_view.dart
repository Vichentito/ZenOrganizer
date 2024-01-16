import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';

class NoteItemView extends StatelessWidget {
  final NotesModel note;
  final VoidCallback onDelete;

  const NoteItemView({
    Key? key,
    required this.note,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int maxChars = 200; // Número máximo de caracteres que quieres mostrar
    String content = note.content;
    if (content.length > maxChars) {
      content =
          '${content.substring(0, maxChars)}...'; // Añade puntos suspensivos si el contenido es más largo
    }
    return GestureDetector(
      onTap: () {
        context.go('/notes/details/${note.id}');
      },
      child: Stack(
        children: [
          // ignore: sized_box_for_whitespace
          Container(
            width: 300, // Ancho fijo para la Card, ajústalo según necesites
            child: Card(
              color: Colors.yellow[100], // Color de post-it
              child: CustomPaint(
                painter: _NoteLinesPainter(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min, // Ajusta la altura al contenido
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Alinea los tags y los botones a los extremos de la fila
                        children: [
                          // Aquí iría el widget o la representación de los tags de la nota
                          Wrap(
                            children: note.tags
                                .map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0), // Ajusta al gusto
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                            color: Colors
                                                .black), // Ajusta el color de texto al gusto
                                      ),
                                    ))
                                .toList(),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize
                                .min, // Para evitar que la Row ocupe todo el ancho disponible
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: onDelete,
                                  iconSize: 18),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              4.0), // Espacio entre la fila de tags/botones y el título
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          height:
                              4.0), // Espacio entre el título y el contenido
                      Text(
                          content // Debería añadir puntos suspensivos si el texto es más largo.
                          )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

    for (var i = lineSpacing; i < size.height; i += lineSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
