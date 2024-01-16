import 'package:zen_organizer/config/domain/datasources/todos_datasource.dart';
import 'package:zen_organizer/config/domain/repositories/todos_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';

class TodoRepositoryImpl extends TodosRepository {
  final TodosDataSource datasource;

  TodoRepositoryImpl(this.datasource);

  @override
  Future<ToDoItemModel> createTodo(ToDoItemModel todoItem) {
    return datasource.createTodo(todoItem);
  }

  @override
  Future<void> deleteTodo(String id) {
    return datasource.deleteTodo(id);
  }

  @override
  Future<ToDoItemModel> getTodoById(String id) {
    return datasource.getTodoById(id);
  }

  @override
  Future<List<ToDoItemModel>> getTodos() {
    return datasource.getTodos();
  }

  @override
  Future<ToDoItemModel> updateTodo(String id, ToDoItemModel todoItem) {
    return datasource.updateTodo(id, todoItem);
  }
}
