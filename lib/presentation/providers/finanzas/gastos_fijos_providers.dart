import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/domain/repositories/finanzas/gasto_fijo_item_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';
import 'package:zen_organizer/presentation/providers/finanzas/gastos_fijos_repository_provider.dart';

class GastosFijosState {
  final AsyncValue<List<GastoFijoModel>> gastosFijosList;

  GastosFijosState({
    required this.gastosFijosList,
  });
}

final gastosFijosStateProvider =
    StateNotifierProvider<GastosFijosNotifier, GastosFijosState>(
  (ref) => GastosFijosNotifier(ref.read(gastosFijosRepositoryProvider)),
);

class GastosFijosNotifier extends StateNotifier<GastosFijosState> {
  GastosFijosNotifier(this._repository)
      : super(GastosFijosState(gastosFijosList: const AsyncValue.loading()));

  final GastoFijoRepository _repository;
  bool _hasLoadedGastos = false;
  List<GastoFijoModel> _originalGastos = [];

  Future<void> loadGastos() async {
    if (_hasLoadedGastos) return;
    try {
      final gastos = await _repository.getGastosFijos();
      state = GastosFijosState(gastosFijosList: AsyncValue.data(gastos));
      _originalGastos = gastos;
      _hasLoadedGastos = true;
    } catch (e, stackTrace) {
      state =
          GastosFijosState(gastosFijosList: AsyncValue.error(e, stackTrace));
    }
  }

  Future<GastoFijoModel> getGastoById(String id) async {
    final currentState = state.gastosFijosList;
    if (currentState is AsyncData<List<GastoFijoModel>>) {
      final gastos = currentState.value;
      final gasto = gastos.firstWhere((gasto) => gasto.id == id);
      return gasto;
    }
    throw Exception('No se ha podido encontrar el gasto');
  }

  Future<void> addGastoInFirestore(GastoFijoModel newGasto) async {
    try {
      GastoFijoModel createdGasto = await _repository.createGastoFijo(newGasto);
      final currentState = state.gastosFijosList;
      if (currentState is AsyncData<List<GastoFijoModel>>) {
        final newGastosList = List<GastoFijoModel>.from(currentState.value)
          ..add(createdGasto);
        state =
            GastosFijosState(gastosFijosList: AsyncValue.data(newGastosList));
        _originalGastos = newGastosList;
      }
    } catch (e, stackTrace) {
      removeLocalGastoItem(newGasto);
      state =
          GastosFijosState(gastosFijosList: AsyncValue.error(e, stackTrace));
    }
  }

  void removeLocalGastoItem(GastoFijoModel newGasto) {
    final currentState = state.gastosFijosList;
    if (currentState is AsyncData<List<GastoFijoModel>>) {
      final updatedGastosList =
          currentState.value.where((gasto) => gasto.id != newGasto.id).toList();
      state =
          GastosFijosState(gastosFijosList: AsyncValue.data(updatedGastosList));
    }
  }

  Future<void> deleteGastoFromFirestore(String id) async {
    try {
      await _repository.deleteGastoFijo(id);
      final currentState = state.gastosFijosList;
      if (currentState is AsyncData<List<GastoFijoModel>>) {
        final updatedGastosList =
            currentState.value.where((gasto) => gasto.id != id).toList();
        state = GastosFijosState(
            gastosFijosList: AsyncValue.data(updatedGastosList));
        _originalGastos = updatedGastosList;
      }
    } catch (e, stackTrace) {
      state =
          GastosFijosState(gastosFijosList: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> updateGastoInFirestore(String id, GastoFijoModel updatedGasto,
      GastoFijoModel originalGasto) async {
    try {
      await _repository.updateGastoFijo(id, updatedGasto);
    } catch (e) {
      // Revertir el cambio local si la actualización en Firestore falla
      revertLocalUpdate(id, originalGasto);
    }
  }

  void revertLocalUpdate(String id, GastoFijoModel originalGasto) {
    final currentState = state.gastosFijosList;
    if (currentState is AsyncData<List<GastoFijoModel>>) {
      final gastos = currentState.value;
      final index = gastos.indexWhere((gasto) => gasto.id == id);
      if (index != -1) {
        gastos[index] = originalGasto;
        state = GastosFijosState(
            gastosFijosList:
                AsyncValue.data(List<GastoFijoModel>.from(gastos)));
      }
    }
  }
}
