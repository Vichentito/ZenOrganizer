import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/domain/repositories/finanzas/plan_anual_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/providers/finanzas/plan_anual_repository_provider.dart';

class PlanAnualState {
  final AsyncValue<List<PlanAnualModel>> planAnualList;

  PlanAnualState({
    required this.planAnualList,
  });
}

final planAnualStateProvider =
    StateNotifierProvider<PlanAnualNotifier, PlanAnualState>(
  (ref) => PlanAnualNotifier(ref.read(planAnualRepositoryProvider)),
);

class PlanAnualNotifier extends StateNotifier<PlanAnualState> {
  PlanAnualNotifier(this._repository)
      : super(PlanAnualState(planAnualList: const AsyncValue.loading()));

  final PlanAnualRepository _repository;
  bool _hasLoadedPlanes = false;
  List<PlanAnualModel> _originalPlanes = [];

  Future<void> loadPlanes() async {
    if (_hasLoadedPlanes) return;
    try {
      final planes = await _repository.getPlanesAnuales();
      state = PlanAnualState(planAnualList: AsyncValue.data(planes));
      _originalPlanes = planes;
      _hasLoadedPlanes = true;
    } catch (e, stackTrace) {
      state = PlanAnualState(planAnualList: AsyncValue.error(e, stackTrace));
    }
  }

  Future<PlanAnualModel> getPlanById(String id) async {
    final currentState = state.planAnualList;
    if (currentState is AsyncData<List<PlanAnualModel>>) {
      final planes = currentState.value;
      final plan = planes.firstWhere((plan) => plan.id == id);
      return plan;
    }
    throw Exception('No se ha podido encontrar el plan');
  }

  Future<void> addPlanInFirestore(PlanAnualModel newPlan) async {
    try {
      PlanAnualModel createdPlan = await _repository.createPlanAnual(newPlan);
      final currentState = state.planAnualList;
      if (currentState is AsyncData<List<PlanAnualModel>>) {
        final newPlanesList = List<PlanAnualModel>.from(currentState.value)
          ..add(createdPlan);
        state = PlanAnualState(planAnualList: AsyncValue.data(newPlanesList));
        _originalPlanes = newPlanesList;
      }
    } catch (e, stackTrace) {
      removeLocalPlanItem(newPlan);
      state = PlanAnualState(planAnualList: AsyncValue.error(e, stackTrace));
    }
  }

  void removeLocalPlanItem(PlanAnualModel newPlan) {
    final currentState = state.planAnualList;
    if (currentState is AsyncData<List<PlanAnualModel>>) {
      final updatedPlanesList =
          currentState.value.where((plan) => plan.id != newPlan.id).toList();
      state = PlanAnualState(planAnualList: AsyncValue.data(updatedPlanesList));
    }
  }

  Future<void> deletePlanFromFirestore(String id) async {
    try {
      await _repository.deletePlanAnual(id);
      final currentState = state.planAnualList;
      if (currentState is AsyncData<List<PlanAnualModel>>) {
        final updatedPlanesList =
            currentState.value.where((plan) => plan.id != id).toList();
        state =
            PlanAnualState(planAnualList: AsyncValue.data(updatedPlanesList));
        _originalPlanes = updatedPlanesList;
      }
    } catch (e, stackTrace) {
      state = PlanAnualState(planAnualList: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> updatePlanInFirestore(String id, PlanAnualModel updatedPlan,
      PlanAnualModel originalPlan) async {
    try {
      await _repository.updatePlanAnual(id, updatedPlan);
      final currentState = state.planAnualList;
      if (currentState is AsyncData<List<PlanAnualModel>>) {
        final planes = currentState.value;
        final index = planes.indexWhere((plan) => plan.id == id);
        if (index != -1) {
          planes[index] = updatedPlan;
          state = PlanAnualState(planAnualList: AsyncValue.data(planes));
        }
      }
    } catch (e) {
      // Revertir el cambio local si la actualización en Firestore falla
      revertLocalUpdate(id, originalPlan);
    }
  }

  void revertLocalUpdate(String id, PlanAnualModel originalPlan) {
    final currentState = state.planAnualList;
    if (currentState is AsyncData<List<PlanAnualModel>>) {
      final planes = currentState.value;
      final index = planes.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        planes[index] = originalPlan;
        state = PlanAnualState(
            planAnualList: AsyncValue.data(List<PlanAnualModel>.from(planes)));
      }
    }
  }

  Future<void> createFullYear() async {
    try {
      await _repository.createFullYear();
      await loadPlanes();
    } catch (e, stackTrace) {
      state = PlanAnualState(planAnualList: AsyncValue.error(e, stackTrace));
    }
  }
}
