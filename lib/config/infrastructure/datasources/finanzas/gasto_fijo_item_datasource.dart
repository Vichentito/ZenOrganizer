import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/domain/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';

class GastoFijodbDatasource implements GastoFijoDataSource {
  final CollectionReference _gastosFijosCollection =
      FirebaseFirestore.instance.collection('gastos_fijos');

  @override
  Future<GastoFijoModel> getGastoFijoById(String id) async {
    DocumentSnapshot doc = await _gastosFijosCollection.doc(id).get();
    if (doc.exists) {
      return GastoFijoModel.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Gasto Fijo not found');
    }
  }

  @override
  Future<List<GastoFijoModel>> getGastosFijos() async {
    QuerySnapshot querySnapshot = await _gastosFijosCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return GastoFijoModel.fromJson(data);
    }).toList();
  }

  @override
  Future<GastoFijoModel> updateGastoFijo(
      String id, GastoFijoModel gastoFijoItem) async {
    await _gastosFijosCollection.doc(id).update(gastoFijoItem.toJson());
    return getGastoFijoById(id);
  }

  @override
  Future<GastoFijoModel> createGastoFijo(GastoFijoModel gastoFijoItem) async {
    DocumentReference docRef =
        await _gastosFijosCollection.add(gastoFijoItem.toJson());
    return getGastoFijoById(docRef.id);
  }

  @override
  Future<void> deleteGastoFijo(String id) async {
    await _gastosFijosCollection.doc(id).delete();
  }
}
