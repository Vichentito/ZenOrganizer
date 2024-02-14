part of 'finanzas_config_bloc.dart';

sealed class FinanzasConfigState extends Equatable {
  const FinanzasConfigState();
  
  @override
  List<Object> get props => [];
}

final class FinanzasConfigInitial extends FinanzasConfigState {}
