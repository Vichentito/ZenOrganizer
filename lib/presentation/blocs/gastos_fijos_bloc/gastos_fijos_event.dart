part of 'gastos_fijos_bloc.dart';

abstract class GastosFijosEvent extends Equatable {
  const GastosFijosEvent();

  @override
  List<Object> get props => [];
}

class LoadGastosFijos extends GastosFijosEvent {}

class SelectGastoFijo extends GastosFijosEvent {
  final String gastoFijoId;

  const SelectGastoFijo(this.gastoFijoId);

  @override
  List<Object> get props => [gastoFijoId];
}

class AddGastoFijo extends GastosFijosEvent {
  final GastoFijoModel newGasto;

  const AddGastoFijo(this.newGasto);

  @override
  List<Object> get props => [newGasto];
}

class UpdateGastoFijo extends GastosFijosEvent {
  final GastoFijoModel updatedGasto;

  const UpdateGastoFijo(this.updatedGasto);

  @override
  List<Object> get props => [updatedGasto];
}

class DeleteGastoFijo extends GastosFijosEvent {
  final String gastoFijoId;

  const DeleteGastoFijo(this.gastoFijoId);

  @override
  List<Object> get props => [gastoFijoId];
}
