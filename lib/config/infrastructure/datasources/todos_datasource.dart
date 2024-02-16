import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/datasources/todos_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/todos_model.dart';

class TodosdbDatasource extends TodosDataSource {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  @override
  Future<ToDoItemModel> createTodo(ToDoItemModel todoItem) async {
    DocumentReference docRef = await _todosCollection.add(todoItem.toJson());
    return todoItem.copyWith(id: docRef.id);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _todosCollection.doc(id).delete();
  }

  @override
  Future<ToDoItemModel> getTodoById(String id) async {
    final docSnapshot = await _todosCollection.doc(id).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      return ToDoItemModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
    }
    throw Exception('ToDoItem not found');
  }

  @override
  Future<List<ToDoItemModel>> getTodos() async {
    final querySnapshot = await _todosCollection.get();
    List<ToDoItemModel> todos_list = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return ToDoItemModel.fromJson(data);
    }).toList();
    todos_list.sort((a, b) => a.priority.compareTo(b.priority));
    return todos_list;
  }

  @override
  Future<ToDoItemModel> updateTodo(ToDoItemModel todoItem) async {
    await _todosCollection.doc(todoItem.id).update(todoItem.toJson());
    return ToDoItemModel.fromJson({
      ...todoItem.toJson(),
      'id': todoItem.id,
    });
  }
}
