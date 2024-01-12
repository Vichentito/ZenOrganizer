class ToDoItem {
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final int priority; // Podría ser un valor numérico o incluso un enum

  ToDoItem(
      {required this.description,
      required this.dueDate,
      this.isCompleted = false,
      this.priority = 1 // Un valor por defecto para la prioridad
      });
}
