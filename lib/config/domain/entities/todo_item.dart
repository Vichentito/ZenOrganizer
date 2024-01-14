class ToDoItem {
  final String id;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final int priority;

  ToDoItem({
    required this.id,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = 1,
  });
}
