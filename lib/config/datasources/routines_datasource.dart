import 'package:zen_organizer/config/infrastructure/models/routines_model.dart';

abstract class RoutinesDataSource {
  Future<DailyRoutine> createRoutine(DailyRoutine routine);
  Future<void> deleteRoutine(String id);
  Future<DailyRoutine> updateRoutine(DailyRoutine routine);
  Future<DailyRoutine> getRoutineById(String id);
  Future<List<DailyRoutine>> getRoutines();
}
