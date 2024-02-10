import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/plan_anual_datasource.dart';
import 'package:zen_organizer/config/infrastructure/repositories/finanzas/plan_anual_repository_impl.dart';

final planAnualRepositoryProvider = Provider((ref) {
  return PlanAnualRepositoryImpl(PlanAnualdbDatasource());
});
