import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';
import 'package:zen_organizer/presentation/providers/todos/todos_providers.dart';
import 'package:zen_organizer/presentation/views/home_views/add_todo_modal_view.dart';
import 'package:zen_organizer/presentation/views/home_views/todoitem_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.read(todosStateProvider.notifier).loadTodos();
  }

  void _showAddTodoModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddTodoModal(
          onAdd: (String description, DateTime dueDate, int priority) {
            final newTodo = ToDoItemModel(
              id: '',
              description: description,
              dueDate: dueDate,
              priority: priority,
              isCompleted: false,
            );
            ref.read(todosStateProvider.notifier).addTodoInFirestore(newTodo);
          },
        );
      },
    );
  }

  void _showEditTodoModal(BuildContext context, ToDoItemModel todo) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddTodoModal(
          existingTodo: todo,
          onAdd: (String description, DateTime dueDate, int priority) {
            final updatedTodo = todo.copyWith(
              description: description,
              dueDate: dueDate,
              priority: priority,
            );
            final originalTodo = todo;
            ref
                .read(todosStateProvider.notifier)
                .updateTodoLocally(todo.id, updatedTodo);
            ref
                .read(todosStateProvider.notifier)
                .updateTodoInFirestore(todo.id, updatedTodo, originalTodo);
          },
        );
      },
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(todosStateProvider.notifier).resetSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final todosState =
        ref.watch(todosStateProvider); // Proveedor de estado de tus todos

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                ),
                onChanged: (searchTerm) {
                  // Llama a una función para filtrar la lista de tareas
                  ref.read(todosStateProvider.notifier).searchTodos(searchTerm);
                },
              )
            : const Text('To-Do List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(
              todosState.isSortedByPriority
                  ? Icons.north_rounded
                  : Icons.south_rounded,
            ),
            onPressed: () {
              ref.read(todosStateProvider.notifier).sortByPriority();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoModal(context),
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: true,
      body: todosState.todosList.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (err, stack) => Text('Error: $err'),
        data: (todos) {
          // Construye tu UI con la lista de todos usando ToDoItemCard
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80.0),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ToDoItemCard(
                todo: todo,
                onCompleted: (bool? newValue) {
                  if (newValue != null) {
                    final originalTodo = todo;
                    final updatedTodo = todo.copyWith(isCompleted: newValue);
                    ref
                        .read(todosStateProvider.notifier)
                        .updateTodoLocally(todo.id, updatedTodo);
                    ref.read(todosStateProvider.notifier).updateTodoInFirestore(
                        todo.id, updatedTodo, originalTodo);
                  }
                },
                onEdit: () {
                  _showEditTodoModal(context, todo);
                },
                onDelete: () {
                  ref
                      .read(todosStateProvider.notifier)
                      .deleteTodoFromFirestore(todo.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
