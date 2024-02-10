import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';

abstract class PlanAnualRepository {
  Future<List<PlanAnualModel>> getPlanesAnuales();
  Future<PlanAnualModel> getPlanAnualById(String id);
  Future<PlanAnualModel> createPlanAnual(PlanAnualModel planAnual);
  Future<PlanAnualModel> updatePlanAnual(String id, PlanAnualModel planAnual);
  Future<void> deletePlanAnual(String id);
  Future<PlanAnualModel?> createFullYear();
}
