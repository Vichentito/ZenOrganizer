part of 'gastos_fijos_bloc.dart';

sealed class GastosFijosState extends Equatable {
  const GastosFijosState();
  
  @override
  List<Object> get props => [];
}

final class GastosFijosInitial extends GastosFijosState {}
