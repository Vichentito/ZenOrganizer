import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zen_organizer/config/datasources/todos_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodosDataSource dataSource;

  TodoBloc(this.dataSource) : super(TodosInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<SortTodosByPriority>(_onSortTodosByPriority);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodosLoading());
    try {
      final todos = await dataSource.getTodos();
      emit(TodosLoaded(todos: todos));
    } catch (error) {
      emit(TodosError(error.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await dataSource.createTodo(event.todo);
      add(LoadTodos()); // Recargar todos los todos después de añadir
    } catch (error) {
      emit(TodosError(error.toString()));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await dataSource.updateTodo(event.todo);
      add(LoadTodos()); // Recargar todos los todos después de actualizar
    } catch (error) {
      emit(TodosError(error.toString()));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await dataSource.deleteTodo(event.id);
      add(LoadTodos()); // Recargar todos los todos después de eliminar
    } catch (error) {
      emit(TodosError(error.toString()));
    }
  }

  Future<void> _onToggleTodoStatus(
      ToggleTodoStatus event, Emitter<TodoState> emit) async {
    try {
      final todo = await dataSource.getTodoById(event.id);
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      await dataSource.updateTodo(updatedTodo);
      add(LoadTodos());
    } catch (error) {
      emit(TodosError(error.toString()));
    }
  }

  Future<void> _onSortTodosByPriority(
      SortTodosByPriority event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final currentState = state as TodosLoaded;
      final todos = currentState.todos.toList();

      if (currentState.isSortedByPriority == 0) {
        todos.sort((a, b) => a.priority.compareTo(b.priority));
        emit(currentState.copyWith(todos: todos, isSortedByPriority: 1));
      } else if (currentState.isSortedByPriority == 1) {
        todos.sort((a, b) => b.priority.compareTo(a.priority));
        emit(currentState.copyWith(todos: todos, isSortedByPriority: 2));
      } else {
        todos.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        emit(currentState.copyWith(todos: todos, isSortedByPriority: 0));
      }
    }
  }
}
