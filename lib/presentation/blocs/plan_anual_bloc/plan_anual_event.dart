part of 'plan_anual_bloc.dart';

abstract class PlanAnualEvent extends Equatable {
  const PlanAnualEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlanesAnuales extends PlanAnualEvent {}

class SelectQuincena extends PlanAnualEvent {
  final Quincena quincena;

  const SelectQuincena(this.quincena);

  @override
  List<Object?> get props => [quincena];
}

class AddPlanAnual extends PlanAnualEvent {
  final PlanAnualModel newPlan;

  const AddPlanAnual(this.newPlan);

  @override
  List<Object?> get props => [newPlan];
}

class UpdatePlanAnual extends PlanAnualEvent {
  final PlanAnualModel updatedPlan;

  const UpdatePlanAnual(this.updatedPlan);

  @override
  List<Object?> get props => [updatedPlan];
}

class DeletePlanAnual extends PlanAnualEvent {
  final String planId;

  const DeletePlanAnual(this.planId);

  @override
  List<Object?> get props => [planId];
}
