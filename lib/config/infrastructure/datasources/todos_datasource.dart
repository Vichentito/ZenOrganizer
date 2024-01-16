import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/domain/datasources/todos_datasource.dart';
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
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return ToDoItemModel.fromJson(data);
    }).toList();
  }

  @override
  Future<ToDoItemModel> updateTodo(String id, ToDoItemModel todoItem) async {
    await _todosCollection.doc(id).update(todoItem.toJson());
    return ToDoItemModel.fromJson({
      ...todoItem.toJson(),
      'id': id,
    });
  }
}
