import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/infrastructure/models/todos/todos_model.dart';

abstract class TodosRepository {
  Future<List<ToDoItemModel>> getTodos();
  Future<ToDoItemModel> getTodoById(String id);
  Future<ToDoItemModel> createTodo(ToDoItemModel todoItem);
  Future<ToDoItemModel> updateTodo(String id, ToDoItemModel todoItem);
  Future<void> deleteTodo(String id);
}
