import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_organizer/config/datasources/finanzas/plan_anual_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';

class PlanAnualdbDatasource extends PlanAnualDataSource {
  final CollectionReference _configCollection =
      FirebaseFirestore.instance.collection('planes_anuales');

  @override
  Future<PlanAnualModel> createPlanAnual(PlanAnualModel planAnual) async {
    final docRef = await _configCollection.add(planAnual.toJson());
    return planAnual.copyWith(id: docRef.id);
  }

  @override
  Future<void> deletePlanAnual(String id) {
    return _configCollection.doc(id).delete();
  }

  @override
  Future<PlanAnualModel> getPlanAnualById(String id) async {
    final doc = await _configCollection.doc(id).get();
    return PlanAnualModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<List<PlanAnualModel>> getPlanesAnuales() async {
    final querySnapshot = await _configCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return PlanAnualModel.fromJson(data);
    }).toList();
  }

  @override
  Future<PlanAnualModel> updatePlanAnual(String id, PlanAnualModel planAnual) {
    return _configCollection
        .doc(id)
        .update(planAnual.toJson())
        .then((_) => planAnual);
  }

  @override
  Future<PlanAnualModel?> createFullYear() async {
    int year = DateTime.now().year;
    List<Quincena> quincenas = [];

    // Check if a plan for the current year already exists
    QuerySnapshot querySnapshot =
        await _configCollection.where('ano', isEqualTo: year).get();
    if (querySnapshot.docs.isNotEmpty) {
      // A plan for the current year already exists, so return null
      return null;
    }

    for (int month = 1; month <= 12; month++) {
      int lastDayOfMonth = DateTime(year, month + 1, 0).day;
      quincenas.add(Quincena(
        fechaInicio: DateTime(year, month, 1),
        fechaFin: DateTime(year, month, 15),
      ));
      quincenas.add(Quincena(
        fechaInicio: DateTime(year, month, 16),
        fechaFin: DateTime(year, month, lastDayOfMonth),
      ));
    }

    PlanAnualModel planAnual = PlanAnualModel(
      id: '', // Firestore will auto-generate this
      ano: year,
      quincenas: quincenas,
    );

    return createPlanAnual(planAnual);
  }
}
