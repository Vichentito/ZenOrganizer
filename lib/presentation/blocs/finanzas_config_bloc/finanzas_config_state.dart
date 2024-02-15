part of 'finanzas_config_bloc.dart';

sealed class FinanzasConfigState extends Equatable {
  const FinanzasConfigState();

  @override
  List<Object> get props => [];
}

class FinanzasConfigInitial extends FinanzasConfigState {}

class FinanzasConfigLoading extends FinanzasConfigState {}

class FinanzasConfigLoaded extends FinanzasConfigState {
  final ConfigModel config;
  final AguinaldoModel aguinaldo;

  const FinanzasConfigLoaded(this.config, this.aguinaldo);

  @override
  List<Object> get props => [config, aguinaldo];
}
