import 'package:intl/intl.dart';

class ToDoItemModel {
  final String id;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final int priority;

  ToDoItemModel({
    required this.id,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = 1,
  });

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
