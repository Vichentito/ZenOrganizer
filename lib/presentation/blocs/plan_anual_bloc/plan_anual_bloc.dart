import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zen_organizer/config/domain/datasources/finanzas/plan_anual_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';

part 'plan_anual_event.dart';
part 'plan_anual_state.dart';

class PlanAnualBloc extends Bloc<PlanAnualEvent, PlanAnualState> {
  final PlanAnualDataSource dataSource;

  PlanAnualBloc(this.dataSource) : super(PlanAnualInitial()) {
    on<LoadPlanesAnuales>(_onLoadPlanesAnuales);
    on<SelectQuincena>(_onSelectQuincena);
    on<AddPlanAnual>(_onAddPlanAnual);
    on<UpdatePlanAnual>(_onUpdatePlanAnual);
    on<DeletePlanAnual>(_onDeletePlanAnual);
  }

  Future<void> _onLoadPlanesAnuales(
      LoadPlanesAnuales event, Emitter<PlanAnualState> emit) async {
    emit(PlanAnualLoading());
    try {
      final planesAnuales = await dataSource.getPlanesAnuales();
      emit(PlanAnualLoaded(planesAnuales: planesAnuales));
    } catch (error) {
      emit(PlanAnualError(error.toString()));
    }
  }

  void _onSelectQuincena(SelectQuincena event, Emitter<PlanAnualState> emit) {
    final currentState = state;
    if (currentState is PlanAnualLoaded) {
      emit(currentState.copyWith(selectedQuincena: event.quincena));
    }
  }

  Future<void> _onAddPlanAnual(
      AddPlanAnual event, Emitter<PlanAnualState> emit) async {
    final currentState = state;
    if (currentState is PlanAnualLoaded) {
      try {
        final newPlan = await dataSource.createPlanAnual(event.newPlan);
        final updatedPlanes =
            List<PlanAnualModel>.from(currentState.planesAnuales)..add(newPlan);
        emit(currentState.copyWith(planesAnuales: updatedPlanes));
      } catch (error) {
        emit(PlanAnualError(error.toString()));
      }
    }
  }

  Future<void> _onUpdatePlanAnual(
      UpdatePlanAnual event, Emitter<PlanAnualState> emit) async {
    final currentState = state;
    if (currentState is PlanAnualLoaded) {
      try {
        await dataSource.updatePlanAnual(
            event.updatedPlan.id, event.updatedPlan);
        final updatedPlanes = currentState.planesAnuales
            .map((plan) =>
                plan.id == event.updatedPlan.id ? event.updatedPlan : plan)
            .toList();
        emit(currentState.copyWith(planesAnuales: updatedPlanes));
      } catch (error) {
        emit(PlanAnualError(error.toString()));
      }
    }
  }

  Future<void> _onDeletePlanAnual(
      DeletePlanAnual event, Emitter<PlanAnualState> emit) async {
    final currentState = state;
    if (currentState is PlanAnualLoaded) {
      try {
        await dataSource.deletePlanAnual(event.planId);
        final updatedPlanes = currentState.planesAnuales
            .where((plan) => plan.id != event.planId)
            .toList();
        emit(currentState.copyWith(planesAnuales: updatedPlanes));
      } catch (error) {
        emit(PlanAnualError(error.toString()));
      }
    }
  }
}
