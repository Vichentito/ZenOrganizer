import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/datasources/finanzas/config_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';

class ConfigdbDatasource extends ConfigDataSource {
  final CollectionReference _configCollection =
      FirebaseFirestore.instance.collection('finanzas_config');

  @override
  Future<ConfigModel> getConfig() async {
    DocumentSnapshot doc =
        await _configCollection.doc('m6mWFGI14UC3NPdvTLrz').get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return ConfigModel.fromJson(data);
    } else {
      throw Exception('Config not found');
    }
  }

  @override
  Future<ConfigModel> updateConfig(ConfigModel configItem) async {
    await _configCollection
        .doc('m6mWFGI14UC3NPdvTLrz')
        .set(configItem.toJson());
    return getConfig();
  }
}

class AguinaldodbDatasource extends AguinaldoDataSource {
  final CollectionReference _aguinaldoCollection =
      FirebaseFirestore.instance.collection('finanzas_config');

  @override
  Future<AguinaldoModel> getAguinaldo() async {
    DocumentSnapshot doc =
        await _aguinaldoCollection.doc('5nDxVO9Ijc7FEtXN7lJ9').get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return AguinaldoModel.fromJson(data);
    } else {
      throw Exception('Aguinaldo not found');
    }
  }

  @override
  Future<AguinaldoModel> updateAguinaldo(AguinaldoModel aguinaldoItem) async {
    await _aguinaldoCollection
        .doc('5nDxVO9Ijc7FEtXN7lJ9')
        .update(aguinaldoItem.toJson());
    return getAguinaldo();
  }
}
