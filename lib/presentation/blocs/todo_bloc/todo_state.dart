part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodosInitial extends TodoState {}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<ToDoItemModel> todos;
  final bool isSortedByPriority;

  const TodosLoaded({
    this.todos = const [],
    this.isSortedByPriority = false,
  });

  TodosLoaded copyWith({
    List<ToDoItemModel>? todos,
    bool? isSortedByPriority,
  }) =>
      TodosLoaded(
        todos: todos ?? this.todos,
        isSortedByPriority: isSortedByPriority ?? this.isSortedByPriority,
      );

  @override
  List<Object?> get props => [todos, isSortedByPriority];
}

class TodosError extends TodoState {
  final String message;

  const TodosError(this.message);

  @override
  List<Object?> get props => [message];
}
