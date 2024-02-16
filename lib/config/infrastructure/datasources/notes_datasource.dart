import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/notes_model.dart';

class NotesdbDatasource extends NotesDataSource {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  @override
  Future<NotesModel> createNote(NotesModel noteItem) async {
    DocumentReference docRef = await _notesCollection.add(noteItem.toJson());
    return noteItem.copyWith(id: docRef.id);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  @override
  Future<NotesModel> getNoteById(String id) async {
    final docSnapshot = await _notesCollection.doc(id).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      data['id'] = docSnapshot.id;
      return NotesModel.fromJson(data);
    }
    throw Exception('ToDoItem not found');
  }

  @override
  Future<List<NotesModel>> getNotes() async {
    final querySnapshot = await _notesCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return NotesModel.fromJson(data);
    }).toList();
  }

  @override
  Future<NotesModel> updateNote(NotesModel noteItem) async {
    await _notesCollection.doc(noteItem.id).update(noteItem.toJson());
    return NotesModel.fromJson({
      ...noteItem.toJson(),
      'id': noteItem.id,
    });
  }
}
