import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/infrastructure/repositories/finanzas/gasto_fijo_impl.dart';

final gastosFijosRepositoryProvider = Provider((ref) {
  return GastoFijoRepositoryImpl(GastoFijodbDatasource());
});
