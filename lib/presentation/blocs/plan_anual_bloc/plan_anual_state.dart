part of 'plan_anual_bloc.dart';

abstract class PlanAnualState extends Equatable {
  const PlanAnualState();

  @override
  List<Object?> get props => [];
}

class PlanAnualInitial extends PlanAnualState {}

class PlanAnualLoading extends PlanAnualState {}

class PlanAnualLoaded extends PlanAnualState {
  final List<PlanAnualModel> planesAnuales;
  final Quincena? selectedQuincena;

  const PlanAnualLoaded({this.planesAnuales = const [], this.selectedQuincena});

  @override
  List<Object?> get props => [planesAnuales, selectedQuincena];

  PlanAnualLoaded copyWith({
    List<PlanAnualModel>? planesAnuales,
    Quincena? selectedQuincena,
  }) {
    return PlanAnualLoaded(
      planesAnuales: planesAnuales ?? this.planesAnuales,
      selectedQuincena: selectedQuincena ?? this.selectedQuincena,
    );
  }
}

class PlanAnualError extends PlanAnualState {
  final String message;

  const PlanAnualError(this.message);

  @override
  List<Object?> get props => [message];
}
