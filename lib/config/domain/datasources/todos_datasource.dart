import 'package:zen_organizer/config/domain/entities/todo_item.dart';

abstract class TodosDataSource {
  Future<List<ToDoItem>> getTodos();
  Future<ToDoItem> getTodoById(int id);
  Future<ToDoItem> createTodo();
  Future<ToDoItem> updateTodo();
  Future<ToDoItem> deleteTodo();
}
