import 'package:zen_organizer/config/domain/datasources/finanzas/config_datasource.dart';
import 'package:zen_organizer/config/domain/repositories/finanzas/config_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigDataSource datasource;

  ConfigRepositoryImpl(this.datasource);

  @override
  Future<ConfigModel> getConfig() {
    return datasource.getConfig();
  }

  @override
  Future<ConfigModel> updateConfig(ConfigModel configItem) {
    return datasource.updateConfig(configItem);
  }
}

class AguinaldoRepositoryImpl implements AguinaldoRepository {
  final AguinaldoDataSource datasource;

  AguinaldoRepositoryImpl(this.datasource);

  @override
  Future<AguinaldoModel> getAguinaldo() {
    return datasource.getAguinaldo();
  }

  @override
  Future<AguinaldoModel> updateAguinaldo(AguinaldoModel aguinaldoItem) {
    return datasource.updateAguinaldo(aguinaldoItem);
  }
}
