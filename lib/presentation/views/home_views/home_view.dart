import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zen_organizer/config/datasources/todos_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/todos_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';
import 'package:zen_organizer/presentation/blocs/todo_bloc/todo_bloc.dart';
import 'package:zen_organizer/presentation/views/home_views/add_todo_modal_view.dart';
import 'package:zen_organizer/presentation/views/home_views/todoitem_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegúrate de tener una instancia de tu fuente de datos.
    final TodosDataSource dataSource = TodosdbDatasource();

    return BlocProvider(
      create: (_) => TodoBloc(dataSource),
      child: const HomeViewBody(),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  HomeViewBodyState createState() => HomeViewBodyState();
}

class HomeViewBodyState extends State<HomeViewBody> {
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
    // Inicializa la carga de todos al iniciar el estado del widget.
    context.read<TodoBloc>().add(LoadTodos());
  }

  void _showAddTodoModal(BuildContext context) {
    final todoBloc = context.read<TodoBloc>();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddTodoModal(
          onAdd: (String description, DateTime dueDate, int priority) {
            final newTodo = ToDoItemModel(
              id: '', // El ID se generaría en el backend o capa de datos.
              description: description,
              dueDate: dueDate,
              priority: priority,
              isCompleted: false,
            );
            todoBloc.add(AddTodo(newTodo));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  // Implementa la funcionalidad de búsqueda aquí si es necesario.
                },
              )
            : const Text('To-Do List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            }),
          ),
          IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () =>
                  context.read<TodoBloc>().add(const SortTodosByPriority())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoModal(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return Column(
                  children: [
                    ToDoItemCard(
                      todo: todo,
                      onCompleted: (bool? newValue) {
                        if (newValue != null) {
                          // Actualiza el estado completado de la tarea.
                          final updatedTodo =
                              todo.copyWith(isCompleted: newValue);
                          context.read<TodoBloc>().add(UpdateTodo(updatedTodo));
                        }
                      },
                      onEdit: () {
                        // Implementa la funcionalidad de edición aquí.
                      },
                      onDelete: () {
                        context.read<TodoBloc>().add(DeleteTodo(todo.id));
                      },
                    ),
                    if (index == state.todos.length - 1)
                      const SizedBox(height: 70), // Añade espacio al final
                  ],
                );
              },
            );
          } else if (state is TodosError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox(); // Estado no manejado
        },
      ),
    );
  }
}
