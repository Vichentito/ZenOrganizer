part of 'finanzas_config_bloc.dart';

sealed class FinanzasConfigEvent {
  const FinanzasConfigEvent();
}

class LoadConfig extends FinanzasConfigEvent {}
