import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';

abstract class ConfigDataSource {
  Future<ConfigModel> getConfig();
  Future<ConfigModel> updateConfig(ConfigModel configItem);
}

abstract class AguinaldoDataSource {
  Future<AguinaldoModel> getAguinaldo();
  Future<AguinaldoModel> updateAguinaldo(AguinaldoModel aguinaldoItem);
}
