// En add_todo_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';

class AddTodoModal extends StatefulWidget {
  final ToDoItemModel? existingTodo;
  final void Function(String description, DateTime dueDate, int priority) onAdd;

  const AddTodoModal({Key? key, this.existingTodo, required this.onAdd})
      : super(key: key);

  @override
  _AddTodoModalState createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  late String description;
  late DateTime dueDate;
  late int priority;

  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingTodo != null) {
      description = widget.existingTodo!.description;
      descriptionController.text = widget.existingTodo!.description;
      dueDate = widget.existingTodo!.dueDate;
      priority = widget.existingTodo!.priority;
    } else {
      description = '';
      dueDate = DateTime.now();
      priority = 1;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          MediaQuery.of(context).viewInsets, // Ajusta el padding al teclado
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Descripción'),
              controller: descriptionController,
              onChanged: (value) {
                description = value;
              },
              autofocus: true,
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  locale: const Locale('es', 'ES'),
                );
                if (picked != null && picked != dueDate) {
                  setState(() {
                    dueDate = DateTime(picked.year, picked.month, picked.day);
                    // Actualiza el controlador del texto para la fecha también si es necesario
                  });
                }
              },
              child: Text(
                'Seleccionar fecha: ${DateFormat('dd-MM-yyyy').format(dueDate)}',
              ),
            ),
            DropdownButton<int>(
              value: priority,
              items: [0, 1, 2, 3].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getPriorityColor(
                          value), // Asegúrate de que esta función esté definida para devolver un color basado en la prioridad
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal:
                            10), // Ajusta el padding según tus necesidades
                    child: Text(
                      'Prioridad $value',
                      style: const TextStyle(
                        color: Colors
                            .white, // Cambia a un color que contraste bien con el fondo
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Centra el texto
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  priority = newValue ?? 1;
                });
              },
              // Estilos adicionales para el DropdownButton
              dropdownColor: Colors
                  .white, // Esto es para el color de fondo del menú desplegable
              isExpanded:
                  true, // Esto hace que el botón del menú desplegable sea tan ancho como su elemento padre
              underline:
                  Container(), // Esto elimina la línea debajo del DropdownButton
              style: const TextStyle(
                  color: Colors
                      .black), // Esto es para el estilo de texto del elemento seleccionado
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                widget.onAdd(descriptionController.text, dueDate, priority);
                // Cierra el modal
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade300;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
