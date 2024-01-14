import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/datasources/todos_datasource.dart';
import 'package:zen_organizer/config/infrastructure/repositories/todo_repository_impl.dart';

final todosRepositoryProvider = Provider((ref) {
  return TodoRepositoryImpl(TodosdbDatasource());
});
