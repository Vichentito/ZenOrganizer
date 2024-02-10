part of 'todo_bloc.dart';

abstract class TodoEvent {
  const TodoEvent();
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final ToDoItemModel todo;
  const AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final ToDoItemModel todo;
  const UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String id;
  const DeleteTodo(this.id);
}

class ToggleTodoStatus extends TodoEvent {
  final String id;
  const ToggleTodoStatus(this.id);
}

class SortTodosByPriority extends TodoEvent {
  const SortTodosByPriority();
}
