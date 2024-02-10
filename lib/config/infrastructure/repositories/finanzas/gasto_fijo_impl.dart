import 'package:zen_organizer/config/domain/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/domain/repositories/finanzas/gasto_fijo_item_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';

class GastoFijoRepositoryImpl implements GastoFijoRepository {
  final GastoFijoDataSource datasource;

  GastoFijoRepositoryImpl(this.datasource);

  @override
  Future<GastoFijoModel> createGastoFijo(GastoFijoModel gastoFijoItem) {
    return datasource.createGastoFijo(gastoFijoItem);
  }

  @override
  Future<void> deleteGastoFijo(String id) {
    return datasource.deleteGastoFijo(id);
  }

  @override
  Future<GastoFijoModel> getGastoFijoById(String id) {
    return datasource.getGastoFijoById(id);
  }

  @override
  Future<List<GastoFijoModel>> getGastosFijos() {
    return datasource.getGastosFijos();
  }

  @override
  Future<GastoFijoModel> updateGastoFijo(
      String id, GastoFijoModel gastoFijoItem) {
    return datasource.updateGastoFijo(id, gastoFijoItem);
  }
}
