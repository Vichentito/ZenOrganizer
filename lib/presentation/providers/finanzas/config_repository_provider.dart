import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/config_datasoruce.dart';
import 'package:zen_organizer/config/infrastructure/repositories/finanzas/config_repository_impl.dart';

final configRepositoryProvider = Provider((ref) {
  return ConfigRepositoryImpl(ConfigdbDatasource());
});

final aguinaldoRepositoryProvider = Provider((ref) {
  return AguinaldoRepositoryImpl(AguinaldodbDatasource());
});
