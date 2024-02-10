import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';

abstract class GastoFijoDataSource {
  Future<List<GastoFijoModel>> getGastosFijos();
  Future<GastoFijoModel> getGastoFijoById(String id);
  Future<GastoFijoModel> createGastoFijo(GastoFijoModel gastoFijoItem);
  Future<GastoFijoModel> updateGastoFijo(
      String id, GastoFijoModel gastoFijoItem);
  Future<void> deleteGastoFijo(String id);
}
