part of 'plan_anual_bloc.dart';

sealed class PlanAnualState extends Equatable {
  const PlanAnualState();
  
  @override
  List<Object> get props => [];
}

final class PlanAnualInitial extends PlanAnualState {}
