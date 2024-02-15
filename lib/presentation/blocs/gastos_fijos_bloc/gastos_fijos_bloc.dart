import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zen_organizer/config/domain/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';

part 'gastos_fijos_event.dart';
part 'gastos_fijos_state.dart';

class GastosFijosBloc extends Bloc<GastosFijosEvent, GastosFijosState> {
  final GastoFijoDataSource dataSource;

  GastosFijosBloc(this.dataSource) : super(GastosFijosInitial()) {
    on<LoadGastosFijos>(_onLoadGastosFijos);
    on<SelectGastoFijo>(_onSelectGastoFijo);
    on<AddGastoFijo>(_onAddGastoFijo);
    on<UpdateGastoFijo>(_onUpdateGastoFijo);
    on<DeleteGastoFijo>(_onDeleteGastoFijo);
  }

  Future<void> _onLoadGastosFijos(
      LoadGastosFijos event, Emitter<GastosFijosState> emit) async {
    emit(GastosFijosLoading());
    try {
      final gastosFijos = await dataSource.getGastosFijos();
      emit(GastosFijosContent(gastosFijos: gastosFijos));
    } catch (error) {
      emit(GastosFijosError(error.toString()));
    }
  }

  void _onSelectGastoFijo(
      SelectGastoFijo event, Emitter<GastosFijosState> emit) {
    final currentState = state;
    if (currentState is GastosFijosContent) {
      // Buscar el gasto fijo por ID, o null si no se encuentra
      final selectedGasto = currentState.gastosFijos
          .firstWhere((gasto) => gasto.id == event.gastoFijoId);
      emit(currentState.copyWith(selectedGastoFijo: selectedGasto));
    }
  }

  Future<void> _onAddGastoFijo(
      AddGastoFijo event, Emitter<GastosFijosState> emit) async {
    final currentState = state;
    if (currentState is GastosFijosContent) {
      try {
        final newGasto = await dataSource.createGastoFijo(event.newGasto);
        final updatedGastos =
            List<GastoFijoModel>.from(currentState.gastosFijos)..add(newGasto);
        emit(currentState.copyWith(gastosFijos: updatedGastos));
      } catch (error) {
        emit(GastosFijosError(error.toString()));
      }
    }
  }

  Future<void> _onUpdateGastoFijo(
      UpdateGastoFijo event, Emitter<GastosFijosState> emit) async {
    final currentState = state;
    if (currentState is GastosFijosContent) {
      try {
        await dataSource.updateGastoFijo(
            event.updatedGasto.id, event.updatedGasto);
        final updatedGastos = currentState.gastosFijos.map((gasto) {
          return gasto.id == event.updatedGasto.id ? event.updatedGasto : gasto;
        }).toList();
        emit(currentState.copyWith(gastosFijos: updatedGastos));
      } catch (error) {
        emit(GastosFijosError(error.toString()));
      }
    }
  }

  Future<void> _onDeleteGastoFijo(
      DeleteGastoFijo event, Emitter<GastosFijosState> emit) async {
    final currentState = state;
    if (currentState is GastosFijosContent) {
      try {
        await dataSource.deleteGastoFijo(event.gastoFijoId);
        final updatedGastos = currentState.gastosFijos
            .where((gasto) => gasto.id != event.gastoFijoId)
            .toList();
        emit(currentState.copyWith(gastosFijos: updatedGastos));
      } catch (error) {
        emit(GastosFijosError(error.toString()));
      }
    }
  }
}
