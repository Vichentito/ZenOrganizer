import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/domain/repositories/todos_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/todos/todos_model.dart';
import 'package:zen_organizer/presentation/providers/todos/todos_repository_provider.dart';

class TodosState {
  final AsyncValue<List<ToDoItemModel>> todosList;
  final bool isSortedByPriority;

  TodosState({
    required this.todosList,
    required this.isSortedByPriority,
  });
}

final todosStateProvider = StateNotifierProvider<TodosNotifier, TodosState>(
  (ref) => TodosNotifier(ref.read(todosRepositoryProvider)),
);

class TodosNotifier extends StateNotifier<TodosState> {
  TodosNotifier(this._repository)
      : super(TodosState(
            todosList: const AsyncValue.loading(), isSortedByPriority: false)) {
    _loadTodos();
  }

  final TodosRepository _repository;

  Future<void> _loadTodos() async {
    try {
      final todos = await _repository.getTodos();
      state = TodosState(
          todosList: AsyncValue.data(todos),
          isSortedByPriority: state.isSortedByPriority);
    } catch (e, stackTrace) {
      state = TodosState(
          todosList: AsyncValue.error(e, stackTrace),
          isSortedByPriority: state.isSortedByPriority);
    }
  }

  void updateTodoLocally(String id, ToDoItemModel updatedTodo) {
    final currentState = state.todosList;
    if (currentState is AsyncData<List<ToDoItemModel>>) {
      final todos = currentState.value;
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index] = updatedTodo;
        // Construimos un nuevo TodosState con la lista actualizada y el valor actual de isSortedByPriority
        state = TodosState(
          todosList: AsyncValue.data(List<ToDoItemModel>.from(todos)),
          isSortedByPriority: state.isSortedByPriority,
        );
      }
    }
  }

  Future<void> updateTodoInFirestore(
      String id, ToDoItemModel updatedTodo, ToDoItemModel originalTodo) async {
    try {
      await _repository.updateTodo(id, updatedTodo);
    } catch (e) {
      // Revertir el cambio local si la actualización en Firestore falla
      revertLocalUpdate(id, originalTodo);
    }
  }

  void revertLocalUpdate(String id, ToDoItemModel originalTodo) {
    final currentState = state.todosList;
    if (currentState is AsyncData<List<ToDoItemModel>>) {
      final todos = currentState.value;
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index] = originalTodo;
        state = TodosState(
          todosList: AsyncValue.data(List<ToDoItemModel>.from(todos)),
          isSortedByPriority: state.isSortedByPriority,
        );
      }
    }
  }

  Future<void> addTodoInFirestore(ToDoItemModel newTodo) async {
    try {
      ToDoItemModel createdTodo = await _repository.createTodo(newTodo);
      final currentState = state.todosList;
      if (currentState is AsyncData<List<ToDoItemModel>>) {
        final newTodosList = List<ToDoItemModel>.from(currentState.value)
          ..add(createdTodo);
        state = TodosState(
          todosList: AsyncValue.data(newTodosList),
          isSortedByPriority: state.isSortedByPriority,
        );
      }
    } catch (e, stackTrace) {
      removeLocalTodoItem(newTodo);
      state = TodosState(
        todosList: AsyncValue.error(e, stackTrace),
        isSortedByPriority: state.isSortedByPriority,
      );
    }
  }

  void removeLocalTodoItem(ToDoItemModel newTodo) {
    final currentState = state.todosList;
    if (currentState is AsyncData<List<ToDoItemModel>>) {
      final updatedTodosList =
          currentState.value.where((todo) => todo.id != newTodo.id).toList();
      state = TodosState(
        todosList: AsyncValue.data(updatedTodosList),
        isSortedByPriority: state.isSortedByPriority,
      );
    }
  }

  Future<void> deleteTodoFromFirestore(String id) async {
    try {
      await _repository.deleteTodo(id);
      final currentState = state.todosList;
      if (currentState is AsyncData<List<ToDoItemModel>>) {
        final updatedTodosList =
            currentState.value.where((todo) => todo.id != id).toList();
        state = TodosState(
          todosList: AsyncValue.data(updatedTodosList),
          isSortedByPriority: state.isSortedByPriority,
        );
      }
    } catch (e, stackTrace) {
      state = TodosState(
        todosList: AsyncValue.error(e, stackTrace),
        isSortedByPriority: state.isSortedByPriority,
      );
    }
  }

  void sortByPriority() {
    final currentState = state;
    final currentTodosList = currentState.todosList;
    final currentIsSortedByPriority = currentState.isSortedByPriority;

    if (currentTodosList is AsyncData<List<ToDoItemModel>>) {
      final todos = currentTodosList.value;
      final sortedTodos = List<ToDoItemModel>.from(todos);

      if (currentIsSortedByPriority) {
        sortedTodos.sort((a, b) => a.priority.compareTo(b.priority));
      } else {
        sortedTodos.sort((a, b) => b.priority.compareTo(a.priority));
      }

      state = TodosState(
        todosList: AsyncValue.data(sortedTodos),
        isSortedByPriority: !currentIsSortedByPriority,
      );
    }
  }

  void searchTodos(String searchTerm) {
    final currentState = state.todosList;
    if (currentState is AsyncData<List<ToDoItemModel>>) {
      final filteredTodos = currentState.value
          .where((todo) =>
              todo.description.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
      state = TodosState(
        todosList: AsyncValue.data(filteredTodos),
        isSortedByPriority: state.isSortedByPriority,
      );
    }
  }

  void resetSearch() {
    _loadTodos();
  }
}
