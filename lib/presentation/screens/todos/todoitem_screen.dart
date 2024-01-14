import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/todos/todos_model.dart';

class ToDoItemCard extends StatelessWidget {
  final ToDoItemModel todo;
  final void Function(bool?) onCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ToDoItemCard({
    Key? key,
    required this.todo,
    required this.onCompleted,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getPriorityColor(todo.priority),
            child: Text(todo.priority.toString()),
          ),
          title: Text(todo.description,
              style: todo.isCompleted
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 3)
                  : null),
          subtitle:
              Text('Fecha: ${DateFormat('dd-MM-yyyy').format(todo.dueDate)}'),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: todo.isCompleted,
                onChanged: onCompleted,
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                  icon: const Icon(Icons.delete_rounded), onPressed: onDelete),
            ],
          )),
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
