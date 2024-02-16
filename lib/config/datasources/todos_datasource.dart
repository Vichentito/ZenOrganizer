import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';

abstract class TodosDataSource {
  Future<List<ToDoItemModel>> getTodos();
  Future<ToDoItemModel> getTodoById(String id);
  Future<ToDoItemModel> createTodo(ToDoItemModel todoItem);
  Future<ToDoItemModel> updateTodo(ToDoItemModel todoItem);
  Future<void> deleteTodo(String id);
}
