part of 'gastos_fijos_bloc.dart';

abstract class GastosFijosState extends Equatable {
  const GastosFijosState();

  @override
  List<Object?> get props => [];
}

class GastosFijosInitial extends GastosFijosState {}

class GastosFijosLoading extends GastosFijosState {}

class GastosFijosContent extends GastosFijosState {
  final List<GastoFijoModel> gastosFijos;
  final GastoFijoModel? selectedGastoFijo;

  const GastosFijosContent({
    this.gastosFijos = const [],
    this.selectedGastoFijo,
  });

  GastosFijosContent copyWith({
    List<GastoFijoModel>? gastosFijos,
    GastoFijoModel? selectedGastoFijo,
  }) {
    return GastosFijosContent(
      gastosFijos: gastosFijos ?? this.gastosFijos,
      selectedGastoFijo: selectedGastoFijo ?? this.selectedGastoFijo,
    );
  }

  @override
  List<Object?> get props => [gastosFijos, selectedGastoFijo];
}

class GastosFijosError extends GastosFijosState {
  final String message;

  const GastosFijosError(this.message);

  @override
  List<Object?> get props => [message];
}
