import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/datasources/routines_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/routines_model.dart'; // Import your routines model

class RoutinesdbDatasource implements RoutinesDataSource {
  final CollectionReference _routinesCollection =
      FirebaseFirestore.instance.collection('daily_routines');

  // Create a DailyRoutine
  @override
  Future<DailyRoutine> createRoutine(DailyRoutine routine) async {
    DocumentReference docRef = await _routinesCollection.add(routine.toJson());
    return routine.copyWith(id: docRef.id);
  }

  // Delete a DailyRoutine
  @override
  Future<void> deleteRoutine(String id) async {
    await _routinesCollection.doc(id).delete();
  }

  // Update a DailyRoutine
  @override
  Future<DailyRoutine> updateRoutine(DailyRoutine routine) async {
    await _routinesCollection.doc(routine.id).update(routine.toJson());
    return routine;
  }

  // Get a DailyRoutine by ID
  @override
  Future<DailyRoutine> getRoutineById(String id) async {
    DocumentSnapshot docSnapshot = await _routinesCollection.doc(id).get();
    if (docSnapshot.exists) {
      // Always check if document exists in Firestore
      return DailyRoutine.fromJson(docSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('Daily Routine not found');
    }
  }

  // Get All DailyRoutines
  @override
  Future<List<DailyRoutine>> getRoutines() async {
    QuerySnapshot querySnapshot = await _routinesCollection.get();
    return querySnapshot.docs
        .map((doc) => DailyRoutine.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
