import 'package:zen_organizer/config/domain/datasources/finanzas/plan_anual_datasource.dart';
import 'package:zen_organizer/config/domain/repositories/finanzas/plan_anual_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';

class PlanAnualRepositoryImpl extends PlanAnualRepository {
  final PlanAnualDataSource datasource;

  PlanAnualRepositoryImpl(this.datasource);

  @override
  Future<PlanAnualModel> createPlanAnual(PlanAnualModel planAnual) {
    return datasource.createPlanAnual(planAnual);
  }

  @override
  Future<void> deletePlanAnual(String id) {
    return datasource.deletePlanAnual(id);
  }

  @override
  Future<PlanAnualModel> getPlanAnualById(String id) {
    return datasource.getPlanAnualById(id);
  }

  @override
  Future<List<PlanAnualModel>> getPlanesAnuales() {
    return datasource.getPlanesAnuales();
  }

  @override
  Future<PlanAnualModel> updatePlanAnual(String id, PlanAnualModel planAnual) {
    return datasource.updatePlanAnual(id, planAnual);
  }

  @override
  Future<PlanAnualModel?> createFullYear() {
    return datasource.createFullYear();
  }
}
