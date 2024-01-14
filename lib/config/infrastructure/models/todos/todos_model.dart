import 'package:intl/intl.dart';
import 'package:zen_organizer/config/domain/entities/todo_item.dart';

class ToDoItemModel extends ToDoItem {
  ToDoItemModel({
    required String id,
    required String description,
    required DateTime dueDate,
    bool isCompleted = false,
    int priority = 1,
  }) : super(
          id: id,
          description: description,
          dueDate: DateTime(dueDate.year, dueDate.month, dueDate.day),
          isCompleted: isCompleted,
          priority: priority,
        );

  factory ToDoItemModel.fromJson(Map<String, dynamic> json) {
    return ToDoItemModel(
      id: json['id'],
      description: json['description'],
      dueDate:
          DateTime.parse(json['dueDate']).toLocal(), // Solo fecha, sin hora
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'dueDate':
          DateFormat('yyyy-MM-dd').format(dueDate), // Formatear como solo fecha
      'isCompleted': isCompleted,
      'priority': priority,
    };
  }

  ToDoItemModel copyWith({
    String? id,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    int? priority,
  }) {
    return ToDoItemModel(
      id: id ?? this.id,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}
